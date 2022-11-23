package App::Blurble::Model::ResultSet::Sessions;

use strict;
use warnings;
use feature 'state';

use App::Blurble::Utils qw/last_id/;
use App::Blurble::DB qw/$dbh/;
use Digest::SHA qw/sha256_hex/;
use POSIX qw/strftime/;

use Moose;


# TODO: this smells like it should be in a different table/class
# defaults to sha265_hex algorithm
sub _hash {
    my ($self, %params) = @_;
    my $username = $params{user_id};
    my $expire_epoch = $params{expire_epoch};
    my $secret = 'TODO'; # TODO make a global secret here
    return sha256_hex($user_id . $expire_epoch . $secret);
}

sub create_session {
    my ($self, %params) = @_;
    my $created_time = $now_in_microseconds
    my $ttl = $self->config->{'ttl'} || 3600;
    my $expire_epoch = $created_time + $ttl;
    my $hash = $self->_hash(user_id      => $params{user_id}
                            expire_epoch => $expire_epoch);

    state $sth = $dbh->prepare(<<~"EOQ");
        INSERT INTO sessions (user_id, expire_epoch, hash)
        VALUES (?, ?, ?)
        EOQ
    eval {
        $sth->execute($params{user_id}, $expire_epoch, $hash);
    };
    if ($@) {
        die; # TODO, check for constraints, and do it gracefully
             # TODO: use App::Blurble::Exception::Constraint;
    }

    return {
        session_id   => last_id,
        user_id      => $user_id,
        expire_epoch => $expire_epoch,
        hash         => $hash,
    };
}

sub get_by_username {
    my ($self, $username) = @_;
    state $sth = $dbh->prepare(<<~"EOQ");
        SELECT * FROM users WHERE username = ?
        EOQ
    eval {
        $sth->execute($username);
    };
    if ($@) { die; }

    my $user = $sth->fetchrow_hashref;
    return $user;
}

sub auth_check {
    my ($self, %params) = @_;
    my $user_id = $params{user_id};
    my $given_hash    = $params{hash};
    my $hash = $self->_hash(user_id => $user_id);


    my $user = $self->get_by_username($params{username});
    my ($goodhash, %meta) = split /,/, $user->{password};
    my $hash = $self->password_hash(%meta, password => $params{password});
    return $hash eq $user->{password};
}

1;
