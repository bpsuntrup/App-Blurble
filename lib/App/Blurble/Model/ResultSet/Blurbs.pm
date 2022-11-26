package App::Blurble::Model::ResultSet::Blurbs;

use strict;
use warnings;
use feature 'state';
use POSIX qw/strftime/;
use App::Blurble::DB qw/$dbh/;
use App::Blurble::Utils qw/last_id/;

use Moose;

# TODO: validation
sub create {
    my ($self, %params) = @_;

    unless ($params{user_id}) {
        die "Need user_id to create a blurb.";
    }

    state $sth_blurb = $dbh->prepare(<<~"EOQ");
        INSERT INTO blurbs (content, date)
        VALUES ( ? , ? )
        EOQ
    state $sth_user_blurb = $dbh->prepare(<<~"EOQ");
        INSERT INTO user_blurbs (user_id, blurb_id)
        VALUES ( ? , ? )
        EOQ
    my $time = strftime('%Y-%m-%d %H:%M:%S', localtime);
    $sth_blurb->execute($params{content}, $time);

    my $blurb_id = last_id;
    $sth_user_blurb->execute($params{user_id}, $blurb_id);


    return {
        blurb_id => $blurb_id,
        date     => $time,
    };
}

# TODO: support pagination or something
sub get_all {
    my ($self, %params) = @_;

    unless ($params{user_id}) {
        die "We needs a user_id."
    }

    state $sth = $dbh->prepare(<<~"EOQ");
        SELECT * FROM blurbs 
        JOIN user_blurbs on user_blurbs.blurb_id = blurbs.blurb_id
        WHERE user_id = ?
        ORDER BY blurb_id DESC
        EOQ

    $sth->execute($params{user_id});

    my @result;
    while (my $hash = $sth->fetchrow_hashref()) {
        push @result, $hash;
    }
    return @result;
}

1;
