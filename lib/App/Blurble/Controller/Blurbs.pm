package App::Blurble::Controller::Blurbs;

use strict;
use warnings;

use Mojo::Base 'Mojolicious::Controller';
use aliased 'App::Blurble::Model';

# This action will render a template
# GET /blurbs
# must have session cookie or redirects to login
sub blurbs {
    my $self = shift;

    # TODO username validation. Make this a helper in all of my controllers. Grep for peanutbutter for more
    my $username = $self->session('username');
    unless ($username) {
        my $url = $self->url_for('/')->query( top_msg => 'You do not have permission to view this page. Please log in.' );
        return $self->redirect_to($url);
    }

    my @blurbs = Model->blurbs->get_all(user_id => $self->session('user_id')); # TODO: this can be optimized easily... at least paginated, right?

    $self->render(template => 'blurbs',
                  username => $username,
                  blurbs   => \@blurbs,
                  handler => 'tt',
                  format  => 'html',);
}

# POST /blurb
# must have auth cookie or redirects to login
sub add_blurb {
    my $self = shift;

    my $rp = $self->req->params->to_hash;


    # TODO username validation. Make this a helper in all of my controllers. Grep for peanutbutter for more
    my $username = $self->session('username');
    unless ($username) {
        my $url = $self->url_for('/')->query( top_msg => 'You do not have permission to view this page. Please log in.' );
        return $self->redirect_to($url);
    }

    Model->blurbs->create(user_id => $self->session('user_id'),
                          content => $rp->{blurb_content});

    $self->redirect_to('/blurbs'); # TODO: make sure this has the right params
}

1;
