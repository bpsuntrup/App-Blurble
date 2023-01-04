package App::Blurble::DB::Txn;
use strict;
use warnings;

use App::Blurble::DB qw/$dbh/;

# TODO: write synopsis. Basically, 
# my $txn = App::Blurble::DB::Txn->new;
# $txn->commit;
# $txn->rollback;
# automatically rolls back transaction when goes out of scope

# TODO: handle nesting gracefully.


sub new {
    my $class = shift;
    $dbh->begin_work;
    my $self = bless { touched => 0 }, $class;
    $self->{scope_guard} = Scope::Guard->new({
        return if $self->{touched};
        $dbh->rollback;
    });
    return $self;
}

sub commit {
    my $self = shift;
    $self->{touched} = 1;
}

sub rollback {
    my $self = shift;
    $self->{touched} = 1;
    $dbh->rollback;
}
