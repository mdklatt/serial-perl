# A writer for tabular data consisting of character-delimited fields.
#
# The position of each scalar field is given as an integer index, and the
# position of an array field is a [beg, len] array where the end is undef for
# a variable-length array.
#
package Serial::Core::DelimitedWriter;
use base qw(Serial::Core::_TabularWriter);

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
    $self->{_delim} = $opts{delim} || "\t";
    return;
}

# Join an array of tokens into a line of text.
#
sub _join {
    my $self = shift @_;
    my ($tokens) = @_;
    return join $self->{_delim}, @{$tokens};
}

1;
