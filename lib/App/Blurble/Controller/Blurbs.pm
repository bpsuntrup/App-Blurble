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

    # TODO username validation. Make this a helper
    # in all of my controllers. Grep for peanutbutter for more
    my $username = $self->session('username');
    unless ($username) {
        my $url = $self->url_for('/')->query( 
            top_msg => 'You do not have permission to view this page. Please log in.'
        );
        return $self->redirect_to($url);
    }

    my @blurbs = Model->blurbs->get_all(
        user_id => $self->session('user_id')
    ); # TODO: this can be optimized easily... at least paginated, right?

    my $content_type = $self->req->headers->content_type;
    if ($content_type =~ /json/) {
        return $self->render(json => { blurbs => \@blurbs });
    }
    else {
        return $self->render(template => 'blurbs-react',
                      username => $username,
                      blurbs   => \@blurbs,
                      handler => 'tt',
                      format  => 'html',);
    }
}

# POST /blurb
# must have auth cookie or redirects to login
sub add_blurb {
    my $self = shift;

    # TODO username validation. Make this a helper in all of my controllers. Grep for peanutbutter for more
    my $username = $self->session('username');
    unless ($username) {
        my $url = $self->url_for('/')->query( top_msg => 'You do not have permission to view this page. Please log in.' );
        return $self->redirect_to($url);
    }

    my $content_type = $self->req->headers->content_type;
    if ($content_type =~ /json/) {
        my $deets = $self->model->blurbs->create(user_id => $self->session('user_id'),
                                                 content => $self->req->json->{blurb_content});
        return $self->render(json => $deets);
    }
    else {
        $self->model->blurbs->create(user_id => $self->session('user_id'),
                                     content => $self->req->param('blurb_content'),);

        return $self->redirect_to('/blurbs'); 
    }
}

# DELETE /blurb/blurb_id
sub delete_blurb {
    my $self = shift;

    # TODO username validation. Make this a helper in all of my controllers. Grep for peanutbutter for more
    my $username = $self->session('username');
    unless ($username) {
        my $url = $self->url_for('/')->query( top_msg => 'You do not have permission to view this page. Please log in.' );
        return $self->redirect_to($url);
    }

    $self->model->blurbs->delete(blurb_id => $self->stash("blurb_id"));
    return $self->render(json => { } );
}


1;
