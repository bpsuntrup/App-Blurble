package App::Blurble::Utils;

use strict;
use warnings;
use feature 'state';

use FindBin qw/$Bin/;
use App::Blurble::DB qw/$dbh/;

use base 'Exporter';
our @EXPORT_OK = qw/ app_base last_id /;

sub app_base {
    return "$Bin/../lib";
}

# TODO: maybe move this to DB class, since it's coupled with sqlite specific function
sub last_id {
    state $sth = $dbh->prepare("SELECT LAST_INSERT_ROWID()");
    $sth->execute();
    my ($id) = $sth->fetchrow_array;
    return $id;
}

1;

