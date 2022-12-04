package App::Blurble::DB;

use strict;
use warnings;

use base 'Exporter';
use feature 'state';
our @EXPORT_OK = qw/ dbh $dbh last_id /;

use DBI;
use App::Blurble::Config qw/config/;

our $dbh = _connect();

sub dbh {
    my ($class, %params) = @_;
    if ($params{reconnect}) {
        $dbh->disconnect;
        $dbh = _connect();
    }
    return $dbh;
}

sub _connect {
    my $dbname = App::Blurble::Config::config()->{dbname};
    my $dbh = DBI->connect("dbi:SQLite:dbname=$dbname", '','',
                           {RaiseError => 1, AutoCommit => 1});
    if (!$dbh) {
        die "Failed to connect to database: ", DBI->errstr();
    }
    return $dbh;
}

# TODO: maybe move this to DB class, since it's coupled with sqlite specific function
sub last_id {
    state $sth = $dbh->prepare("SELECT LAST_INSERT_ROWID()");
    $sth->execute();
    my ($id) = $sth->fetchrow_array;
    return $id;
}
                     

1;
