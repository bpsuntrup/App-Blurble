package App::Blurble::Controller::Login;

use strict;
use warnings;

use Mojo::Base 'Mojolicious::Controller';

# GET /login
# if successful, gives auth cookie, redirects to /blurbs
sub login_now {
    my $self = shift;
    my $rp = $self->req->params->to_hash;
    my ($username) = $rp->{username} =~ s/^\s+|\s+$//gr;
    my $user = $self->model->users->get_by_username($username, password_please => 1);
    my $auth = $user && $self->model->users->auth_check(user => $user, password => $rp->{password});
    if ($auth) {
        $self->session(username => $user->{username});
        $self->session(user_id  => $user->{user_id});

        return $self->redirect_to('/blurbs');
    }
    else {
        my $url = $self->url_for('/')->query( login_msg => 'Invalid login credentials' );
        return $self->redirect_to($url);
    }
}

# DELETE /login
# POST   /unlogin
sub log_out {
    my $self = shift;
    delete $self->session->{username};
    return $self->redirect_to('/');
}

1;
