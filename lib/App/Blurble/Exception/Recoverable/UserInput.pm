# user errors we can recover from by sending the user a message
package App::Blurble::Exception::Recoverable::UserInput;

use strict;
use warnings;

use Moose;
extends App::Blurble::Exception;

1;
