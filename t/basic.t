use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

use App::Blurble::Config qw/config/;

$ENV{BLURBLE_SET_CONFIG} = 'dbname,q(testdb)';
my $t = Test::Mojo->new('App::Blurble');

is(config()->{dbname}, 'testdb', 'connected to test db');

#$t->get_ok('/')->status_is(200)->content_like(qr/log in/i);

# test that login strips whitespace
# need to set up mock DB or something, i guess.

#$t->get_ok('/login?')->

# test that login gives cookie, redirects to /blurbs

done_testing();
