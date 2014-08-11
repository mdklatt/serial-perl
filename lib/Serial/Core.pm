package Serial::Core;

use 5.008;
use strict;
use warnings;

# Use Semantic Versioning within the limits of Perl version numbers. Versions
# ending in 0 are releases, others are dev versions working towards the next
# higher release, e.g. 0.001002_001 is equivalent to 0.1.3dev.

our $VERSION = eval '0.000000_001';  # 0.1.0dev

# Make the following classes available by default.

use Serial::Core::DelimitedReader;
use Serial::Core::DelimitedWriter;
use Serial::Core::FixedWidthReader;
use Serial::Core::FixedWidthWriter;
use Serial::Core::ScalarField;
use Serial::Core::FieldFilter;
use Serial::Core::RangeFilter;

1;

__END__

=pod 

=encoding utf8

=head1 NAME

Serial::Core - read and write sequential record-oriented data

=head1 SYNOPSIS

    use Serial::Core;

=head1 DESCRIPTION

The Serial::Core library provides tools for reading and writing sequential
record-oriented data. The library defines I<Reader> classes for parsing data 
from an input stream and I<Writer> classes for writing data to an output 
stream. Both I<Reader>s and I<Writer>s support filtering via callbacks.

=head1 EXPORTS

These classes are available by default. Other library classes must be imported
explicitly.

=over

=item I<DelimitedReader>

Reads character-delimited tabular data.

=item I<DelimitedWriter>

Writes character-delimited tabular data.

=item I<FixedWidthReader>

Reads fixed-width tabular data.

=item I<FixedWidthWriter>

Writes fixed-width tabular data.

=item I<ScalarField>

Define a scalar input/ouput field.

=item I<FieldFilter>

Filter input/output using a set of field values.

=item I<RangeFilter>

Filter input/output using a numerical range of field values.

=back

=cut
