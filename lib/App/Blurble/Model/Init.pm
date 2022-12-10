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

    $dbh->do(<<~"EOQ");
        CREATE TABLE IF NOT EXISTS schema_changes(
            schema_change_id INTEGER PRIMARY KEY AUTOINCREMENT
        )
        EOQ

    my $sth = $dbh->prepare(<<~"EOQ");
        SELECT schema_change_id
        FROM schema_changes
        ORDER BY schema_change_id DESC
        LIMIT 1
        EOQ
    $sth->execute();
    my $result = $sth->fetchall_arrayref();
    my $last_schema_change = $result->[0][0] || 0;
    my @schema_change_methods = grep { $_ =~ /schema_change_(\d{4})/ && $1 > $last_schema_change }
                                keys %App::Blurble::Model::Init::;

    foreach my $method (@schema_change_methods) {
        no strict 'refs';
        $method->();
    }
}

sub schema_change_0001 {
    # check to see if passwords exists
    # if it does, nothing
    # otherwise, create it,
    # then migrate passwords from users to this table
    # then delete column

    $dbh->do(<<~"EOQ");
        CREATE TABLE IF NOT EXISTS passwords(
            password_id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            hash TEXT NOT NULL,
            encrypted_value TEXT,
            FOREIGN KEY (user_id) REFERENCES users (user_id)
        )
        EOQ
    my $sth = $dbh->prepare(<<~"EOQ");
        SELECT user_id, password
        FROM users
        EOQ
    $sth->execute();
    my $result = $sth->fetchall_arrayref();

    my $insert_sth = $dbh->prepare(<<~"EOQ");
        INSERT INTO passwords (user_id, hash)
        VALUES (?, ?)
        EOQ
    for my $value (@$result) {
        $insert_sth->execute($value->[0], $value->[1]);
    }

    $dbh->do(<<~"EOQ");
        ALTER TABLE users DROP COLUMN password
        EOQ

    $dbh->do("INSERT INTO schema_changes (schema_change_id) VALUES (1)");
}


1;
