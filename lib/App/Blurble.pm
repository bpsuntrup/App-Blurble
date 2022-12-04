package App::Blurble;

use strict;
use warnings;
use feature 'state';

use Mojo::Base 'Mojolicious';
use App::Blurble::Utils qw/app_base/;
use aliased 'App::Blurble::Model';
use aliased 'App::Blurble::Biz';
use App::Blurble::Config qw/config/;

# This method will run once at server start
sub startup {
warn "Starting up application";
  my $self = shift;

  $self->plugin('tt_renderer');

  $self->renderer->default_handler('tt');

  $self->helper(model => Model);
  $self->helper(biz   => Biz);

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('main#index');
  $r->get('/login')->to('login#login_now');
  $r->post('/user')->to('user#create_user_now');
  $r->post('/unlogin')->to('login#log_out');
  $r->delete('/login')->to('login#log_out');


  # These need to be protected by auth. Need to check cookies before rendering,
  # if auth fails, give a reason (session expired or not authorized) then direct
  # to /login TODO: figure out how to do that up at this level
  $r->get('/blurbs')->to('blurbs#blurbs');
  $r->post('/blurb')->to('blurbs#add_blurb');
  $r->delete('/blurb/:blurb_id')->to('blurbs#delete_blurb');
}


1;
