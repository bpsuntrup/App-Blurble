package App::Blurble::Config;

use App::Blurble::Utils qw/app_base/;

use base 'Exporter';
our @EXPORT_OK = qw/config/;

our $config;

sub config {
    return $config if $config;

    my $file = $ENV{BLURBLE_CONFIG} || app_base . '/../app-blurble.conf';
    $config = do $file;

    if (my $set_conf = $ENV{BLURBLE_SET_CONFIG}) {
        my %confs = split /,/, $set_conf;
        $config = { %$config, map { ($_ => eval $confs{$_}) } keys %confs };
    }

    return $config;
}

1;
