# A reader for tabular data consisting of character-delimited fields.
#
# The position of each scalar field is given as an integer index, and the
# position of an array field is a [beg, len] array where the end is undef for
# a variable-length array.
#
package Serial::Core::DelimitedReader;
use base qw(Serial::Core::_TabularReader);

use strict;
use warnings;

# Initialize this object.
#
# If no delimiter is specified each input line will be split on whitespace.
#
sub _init {
    my $self = shift @_;
    my ($stream, $fields, %opts) = @_;
    $self->SUPER::_init($stream, $fields, %opts);
    $self->{_delim} = $opts{delim};
    return;
}

# Split a line of text into an array of tokens.
#
sub _split {
    my $self = shift @_;
    my ($line) = @_;
    my @tokens;
    if (!$self->{_delim}) {
        # Split on any whitespace. A literal ' ' must be used; this cannot be
        # a variable.
        @tokens = split ' ', $line;
    }
    else {
        @tokens = split $self->{_delim}, $line;
    }
    return \@tokens;
}

1;
