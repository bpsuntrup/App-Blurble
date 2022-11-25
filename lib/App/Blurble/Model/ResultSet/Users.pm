package App::Blurble::Model::ResultSet::Users;

use strict;
use warnings;
use feature 'state';
use feature 'fc';

use App::Blurble::Utils qw/last_id/;
use App::Blurble::DB qw/$dbh/;
use Digest::SHA qw/sha256_hex/;
use POSIX qw/strftime/;

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
        INSERT INTO users (username, fc_username, password, created_date)
        VALUES (?, ?, ?, ?)
        EOQ

    eval {
        $sth->execute($params{username}, fc $params{username}, $password_hash, $created_date);
    };
    if ($@) {
        die; # TODO, check for constraints, and do it gracefully
             # TODO: use App::Blurble::Exception::Constraint;
    }

    return last_id;
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
    my ($self, $username) = @_;
    state $sth = $dbh->prepare(<<~"EOQ");
        SELECT * FROM users WHERE fc_username = ?
        EOQ
    eval {
        $sth->execute(fc $username);
    };
    die if $@; # TODO: handle gracefully

    my $user = $sth->fetchrow_hashref;
    return $user;
}

sub auth_check {
    my ($self, %params) = @_;
    if (!$params{username} && !$params{user} ) {
        die "Must have username or user";
    }
    my $user  = $params{user} || $self->get_by_username($params{username});
    my ($goodhash, %meta) = split /,/, $user->{password};
    my $hash = $self->_password_hash(%meta, password => $params{password});
    return $hash eq $user->{password};
}

1;
