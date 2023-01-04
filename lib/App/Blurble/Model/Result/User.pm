package App::Blurble::Model::Result::Users;
use strict;
use warnings;

use aliased 'App::Blurlbe::Model';
use aliased 'App::Blurble::DB::Txn';

use Moose;

# There is a logical dependency between this code and the front end
# form validation in templates/index.html.tt
sub is_valid_username {
    my ($self, %params) = @_;
    my $username = $params{username};

    return $username =~ /^[a-zA-Z][a-zA-Z_0-9]*$/;
}

sub password {
    my $self = shift;

    state $get_sth = $self->dbh->prepare('SELECT pa');
    my 

        
    if (@_) {
    }
    else {
        my $password = Model->passwords->get_latest_by_user_id(user_id => $self->id);
    }
}

has id => (
    is => 'ro',
    isa => 'Int',
    required => 1,
    lazy => 1,
    builder => '_build_id'
);

sub _build_id { # TODO: autoload?
    gh
}

1;
