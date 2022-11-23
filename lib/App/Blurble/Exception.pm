package App::Blurble::Exception;

use strict;
use warnings;

use Moose;

has msg => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

# TODO: check this is right
sub PROPAGATE {
    my $self = shift;
    return $self->msg;
}

1;
