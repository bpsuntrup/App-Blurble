#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/../lib" }
use App::Blurble::DB qw/$dbh/;

$dbh->do(<<~"EOQ");
    CREATE TABLE IF NOT EXISTS users(
        user_id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL,
        created_date TEXT NOT NULL,
        UNIQUE(username)
    )
    EOQ
$dbh->do(<<~"EOQ");
    CREATE TABLE IF NOT EXISTS user_blurbs(
        user_blurb_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        blurb_id INTEGER NOT NULL,
        UNIQUE(user_id, blurb_id),
        FOREIGN KEY (user_id) REFERENCES users (user_id),
        FOREIGN KEY (blurb_id) REFERENCES blurbs (blurb_id)
    )
    EOQ
$dbh->do(<<~"EOQ");
    CREATE TABLE IF NOT EXISTS blurbs(
        blurb_id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT,
        date TEXT NOT NULL
    )
    EOQ

