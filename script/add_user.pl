#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/../lib" }
use App::Blurble::DB qw/$dbh/;
use aliased 'App::Blurble::Model::ResultSet::Users';
use Getopt::Long;

my ($username, $password);
GetOptions(
    'username=s' => \$username,
    'password=s' => \$password,
);


Users->create(username => $username, password => $password);
