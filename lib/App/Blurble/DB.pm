package App::Blurble::DB;

use strict;
use warnings;

use App::Blurble;

use base 'Exporter';
our @EXPORT_OK = qw/ dbh $dbh /;

use DBI;

our $dbh = _connect();

sub dbh {
    my ($class, %params) = @_;
    my $dbname = App::Blurble->config->{dbname};
    if ($params{reconnect}) {
        $dbh->disconnect;
        return _connectDBI->connect("dbi:SQLite:dbname=$dbname", '','',
                            {RaiseError => 1, AutoCommit => 1});
    }
    return $dbh;
}

sub _connect {
    my $dbh =  DBI->connect('dbi:SQLite:dbname=blurdb', '','',
                            {RaiseError => 1, AutoCommit => 1});
    if (!$dbh) {
        die "Failed to connect to database: ", DBI->errstr();
    }
    return $dbh;
}
                     

1;
