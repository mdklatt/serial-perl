# A reader for tabular data consisting of fixed-width fields.
#
# The position of each field is given as a [beg, len] array.
#
package Serial::Core::FixedWidthReader;
use base qw(Serial::Core::_TabularReader);

use strict;
use warnings;

use Data::Dumper;

# Split a line of text into an array of tokens.
#
sub _split {
    my ($self, $line) = @_;
    my @tokens = map { 
        my ($pos, $len) = @{$_->{pos}}; 
        substr($line, $pos, $len);
    } @{$self->{_fields}};
    return \@tokens; 
}

1;
