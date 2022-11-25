package App::Blurble::Biz::Users;
use strict;
use warnings;

use Moose;

# There is a logical dependency between this code and the front end
# form validation in templates/index.html.tt
sub is_valid_username {
    my ($self, %params) = @_;
    my $username = $params{username};

    return $username =~ /^[a-zA-Z][a-zA-Z_0-9]*$/;
}

1;
