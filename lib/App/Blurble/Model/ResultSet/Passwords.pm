package App::Blurble::Model::ResultSet::Passwords;

use strict;
use warnings;
use feature 'state';

use App::Blurble::DB qw/$dbh/;

sub new {
    return bless {}, shift;
}

sub fetch_by_user_id {
    my ($self, $user_id, %params) = @_;

    state $sth = $dbh->prepare(<<~"EOQ");
        SELECT * FROM passwords WHERE user_id = ?
        ORDER BY password_id DESC
        LIMIT 1
        EOQ
    eval {
        $sth->execute($user_id);
    };
    die if $@; # TODO: handle gracefully

    my $password = $sth->fetchrow_hashref;

    return $password;
}
    
1;
