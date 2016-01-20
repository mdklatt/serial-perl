package Serial::Core;

use 5.008;
use strict;
use warnings;

# This project uses Semantic Versioning <http://semver.org>. Major versions
# introduce significant changes to the API, and backwards compatibility is not
# guaranteed. Minor versions are for new features and backwards-compatible
# changes to the API. Patch versions are for bug fixes and internal code
# changes that do not affect the API. Version 0.x should be considered a
# development version with an unstable API, and backwards compatibility is not
# guaranteed for minor versions.
#
# David Golden's recommendations for version numbers <http://bit.ly/1g8EbKi> 
# are used, e.g. v0.1.2 is "0.001002" and v1.2.3dev4 is "1.002002_004".

our $SEMANTIC_VERSION = '0.2.2';  # don't forget to update $VERSION
our $VERSION = '0.002002_000';  # don't forget to update $SEMANTIC_VERSION
$VERSION = eval $VERSION;  # runtime conversion to numeric value


# Make the following classes available by default.

use Serial::Core::DelimitedReader;
use Serial::Core::DelimitedWriter;
use Serial::Core::FixedWidthReader;
use Serial::Core::FixedWidthWriter;
use Serial::Core::ConstField;
use Serial::Core::ScalarField;
use Serial::Core::TimeField;
use Serial::Core::FieldFilter;
use Serial::Core::RangeFilter;

1;

__END__

=pod

=encoding utf8

=head1 NAME

Serial::Core - Read and write sequential record-oriented data.

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

=item I<ScalarField>

Define a constant value input/ouput field.

=item I<FieldFilter>

Filter input/output using a set of field values.

=item I<RangeFilter>

Filter input/output using a numerical range of field values.

=back

=cut
