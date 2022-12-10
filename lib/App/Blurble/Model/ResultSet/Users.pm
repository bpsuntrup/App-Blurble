package App::Blurble::Model::ResultSet::Users;

use strict;
use warnings;
use feature 'state';
use feature 'fc';

use App::Blurble::DB qw/$dbh last_id/;
use Digest::SHA qw/sha256_hex/;
use POSIX qw/strftime/;
use aliased 'App::Blurble::Model';

sub new {
    return bless {}, shift;
}

sub create {
    my ($self, %params) = @_;

    # look before you leap
    if ($self->get_by_username($params{username})) {
        return;
    }

    my $created_date = strftime('%Y-%m-%d %H:%M:%S', localtime);
    my $password_hash = $self->_password_hash(password => $params{password});
    state $sth = $dbh->prepare(<<~"EOQ");
        INSERT INTO users (username, fc_username, created_date)
        VALUES (?, ?, ?)
        EOQ
    state $pass_sth = $dbh->prepare(<<~"EOQ");
        INSERT INTO passwords (user_id, hash)
        VALUES (?, ?)
        EOQ

    my $user_id;
    eval {
        $sth->execute($params{username}, fc $params{username}, $created_date);
        $user_id = last_id;
        $pass_sth->execute($user_id, $password_hash);
    };
    if ($@) {
        die; # TODO, check for constraints, and do it gracefully
             # TODO: use App::Blurble::Exception::Constraint;
    }

    return $user_id;
}

# TODO: this smells like it should be in a different table/class. See ResultSet::Sessions, which uses similar
# defaults to sha265_hex algorithm
sub _password_hash {
    my ($self, %params) = @_;
    my $salt = $params{salt} || int rand 1_000_000;
    if (!$params{alg} || $params{alg} eq 'sha256_hex') {
        return sha256_hex($params{password}) . ",alg,sha256_hex,salt,$salt";
    }
    else {
        die "Unimplemented hashing algorithm " . $params{alg};
    }
}


sub get_by_username {
    my ($self, $username, %params) = @_;
    state $sth = $dbh->prepare(<<~"EOQ");
        SELECT * FROM users WHERE fc_username = ?
        EOQ
    eval {
        $sth->execute(fc $username);
    };
    die if $@; # TODO: handle gracefully

    my $user = $sth->fetchrow_hashref;

    if ($params{password_please} && $user) {
        my $password = Model->passwords->fetch_by_user_id($user->{user_id});
        $user->{password} = $password->{hash};
    }

    return $user;
}

sub auth_check {
    my ($self, %params) = @_;
    if (!$params{username} && !$params{user} ) {
        die "Must have username or user";
    }
    my $user  = $params{user} || $self->get_by_username($params{username}, password_please => 1);
    die "Must have password" unless $user->{password};
    my ($goodhash, %meta) = split /,/, $user->{password};
    my $hash = $self->_password_hash(%meta, password => $params{password});
    return $hash eq $user->{password};
}

1;
