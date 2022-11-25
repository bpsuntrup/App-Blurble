package App::Blurble::Model;

use strict;
use warnings;
use Mojo::Util qw/decamelize/;
use Sub::Name;
use File::Slurp qw/read_dir/;
use App::Blurble::Utils qw/app_base/;

# This allows for Model->users, Model->blurbs, etc.
sub _lazy_build_singleton {
    my ($package, $class) = @_;
    
    my $resultset;

    return subname $class => sub {
        return $resultset if $resultset;
        $resultset = $package->new;
        return $resultset;
    };
}

our $RESULTSET_PATH = 'App::Blurble::Model::ResultSet';

our @RESULTSET_CLASSES;
{
    my $resultset_dir = app_base . "/App/Blurble/Model/ResultSet";
    @RESULTSET_CLASSES = map { s/\.pm$//r } grep { /^[^\.]/ } read_dir($resultset_dir);
}


for my $class (@RESULTSET_CLASSES) {
    my $package = $RESULTSET_PATH . '::' . $class;
    eval "require $package";
    $App::Blurble::Model::{decamelize $class} = _lazy_build_singleton($package, decamelize $class);
}

1;
