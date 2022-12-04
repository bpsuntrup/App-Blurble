package App::Blurble::Model::Init;

use strict;
use warnings;

use App::Blurble::DB qw/$dbh/;

sub init_db {
    $dbh->do(<<~"EOQ");
        CREATE TABLE IF NOT EXISTS users(
            user_id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            fc_username TEXT NOT NULL,
            display_name TEXT,
            password TEXT NOT NULL,
            created_date TEXT NOT NULL,
            UNIQUE(username),
            UNIQUE(fc_username)
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
}

1;
