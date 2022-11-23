package App::Blurb::Model::ResultSet;

use strict;
use warnings;

use App::Blurble::DB qw/$dbh/;

use Moose;

has dbh => (
    is  => 'ro',
    default => $dbh,
);

1;
