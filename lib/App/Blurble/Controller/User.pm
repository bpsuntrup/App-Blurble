package App::Blurble::Controller::User;

use strict;
use warnings;

use Mojo::Base 'Mojolicious::Controller';

# POST /user
# redirects to /blurbs with new user logged in, I guess
# TODO: make this act differentially for content-type
# TODO: validate username, trim whitespace, etc
sub create_user_now {
    my $self = shift;
    my $rp = $self->req->params->to_hash;
    my $username = $rp->{username};

    unless ($self->biz->users->is_valid_username(username => $username)) {
        my $url = $self->url_for('/')->query( 
            user_msg => "Username is invalid. Try another one."
        );
        return $self->redirect_to($url);
    }

    my $user_id = $self->model->users->create( %${rp}{qw/username password/} );

    unless ($user_id) {
        my $url = $self->url_for('/')->query( user_msg => "Username exists. Please choose another." );
        return $self->redirect_to($url);
    }

    my $url = $self->url_for('/')->query( top_msg => "User $rp->{username} created successfully. You may log in." );
    return $self->redirect_to($url);
}

1;
