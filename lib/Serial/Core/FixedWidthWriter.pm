# A writer for tabular data consisting of fixed-width fields.
#
#
package Serial::Core::FixedWidthWriter;
use base qw(Serial::Core::_TabularWriter);

use strict;
use warnings;

# Join an array of tokens into a line of text.
#
sub _join {
    # In this implementation the field positions don't matter; tokens must be
    # in the correct order, and tokens must be the correct width for that 
    #  field.
    my $self = shift @_;
    my ($tokens) = @_;
    return join '', @{$tokens};
}

1;
