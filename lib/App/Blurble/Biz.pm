package App::Blurble::Biz;

use strict;
use warnings;
use Mojo::Util qw/decamelize/;
use Sub::Name;
use File::Slurp qw/read_dir/;
use App::Blurble::Utils qw/app_base/;

our $BIZ_PATH = 'App::Blurble::Biz';

our @BIZ_CLASSES;
{
    my $biz_dir = app_base . "/App/Blurble/Biz";
    @BIZ_CLASSES = map { s/\.pm$//r } grep { /^[^\.]/ } read_dir($biz_dir);
}


for my $class (@BIZ_CLASSES) {
    my $package = $BIZ_PATH . '::' . $class;
    eval "require $package";
    $App::Blurble::Biz::{decamelize $class} = _lazy_build_singleton($package, decamelize $class);
}

# This allows for Biz->users, Biz->blurbs, etc.
sub _lazy_build_singleton {
    my ($package, $class) = @_;
    
    my $biz;

    return subname "_biz_method" => sub {
        return $biz if $biz;
        $biz = $package->new;
        return $biz;
    };
}


1;
