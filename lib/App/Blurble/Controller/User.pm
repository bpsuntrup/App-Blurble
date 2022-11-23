package App::Blurble::Controller::User;

use strict;
use warnings;

use Mojo::Base 'Mojolicious::Controller';
use aliased 'App::Blurble::Model';

# POST /user
# redirects to /blurbs with new user logged in, I guess
# TODO: make this act differentially for content-type
# TODO: validate username, trim whitespace, etc
sub create_user_now {
    my $self = shift;
    my $rp = $self->req->params->to_hash;

    my $user_id = eval {
        Model->users->create( %${rp}{qw/username password/} );
    };

    if ($@) {
        if (ref $@ eq 'App::Blurble::Exception::Constraint') { # we have a bad name. Probably in-use username
            # we have a bad name. Probably in-use username
            my $url = $self->url_for('/')->query( user_msg => $@->msg );
            return $self->redirect_to($url);
        }
        else {
            die;
        }
    }

    my $url = $self->url_for('/')->query( top_msg => "User $rp->{username} created successfully. You may log in." );
    return $self->redirect_to($url);
}

1;
