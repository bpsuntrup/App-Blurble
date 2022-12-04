#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/../lib" }
use App::Blurble::Model::Init;

App::Blurble::Model::Init->init_db;
