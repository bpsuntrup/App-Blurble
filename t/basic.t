use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('App::Blurble');
$t->get_ok('/')->status_is(200)->content_like(qr/log in/i);

# test that login strips whitespace
# need to set up mock DB or something, i guess.

#$t->get_ok('/login?')->

# test that login gives cookie, redirects to /blurbs

done_testing();
