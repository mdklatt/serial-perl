# A reader for tabular data consisting of fixed-width fields.
#
# The position of each field is given as a [beg, len] array.
#
package Serial::Core::FixedWidthReader;
use base qw(Serial::Core::_TabularReader);

use strict;
use warnings;

# Split a line of text into an array of tokens.
#
sub _split {
    my $self = shift @_;
    my ($line) = @_;
    my @tokens = map { 
        my ($pos, $len) = @{$_->{pos}}; 
        substr($line, $pos, $len);
    } @{$self->{_fields}};
    return \@tokens; 
}

1;

__END__

=pod

=encoding utf8


=head1 NAME

Serial::Core::FixedWidthReader - read fixed-width tabular data


=head1 SYNOPSIS

    use Serial::Core;

    my $reader = Serial::Core::FixedWidthReader->new($stream, $fields);
    $reader->filter(sub {
        # Add a callback for input preprocessing.
        my ($record) = @_;
        ...
        return $record;  # or undef to drop this record
    };);
    while (my $record = $reader->next()) {
        # Process each record.
        ...
    }


=head1 DESCRIPTION

A I<FixedWidthReader> reads fixed-width tabular data where each field occupies
the same character positions in each input line. One line of input corresponds 
to one data record. 

=head2 CLASS METHODS

=over

=item new($stream, $fields, endl => $/)

Return a new I<FixedWidthReader> object. 

=back

=head3 Required Positional Arguments

=over

=item I<stream> 

A handle to the input stream, which is any object for which 
C<E<lt>$streamE<gt>> returns a line of input.

=item I<fields>

An arrayref of one or more field definitions that define the input layout.

=back

=head3 Optional Named Arguments

=over

=item I<endl>

Specify the endline character(s) to use.

=back

=head2 OBJECT METHODS

=over

=item filter([$callback1, $callback2, ...])

Add one or more filters to the reader, or without any arguments clear all
filters. Filters are applied to each incoming record in the order they were
added; filtering stops as soon as any filter drops the record.

=back

=head3 Optional Positional Arguments

=over

=item I<callback ...> 

Specify callbacks to use as filters. A filter takes a data record as its only
argument and returns that record, a new/modified record, or C<undef> to drop
the record. 

=back

=over

=item next()

Return the next parsed and filtered record from the input stream. Each record 
is a hash keyed by the field names. On EOF C<undef> is returned, so this can be 
used in a C<while> loop.

=item read()

Return all records from the stream as an array or arrayref.

=back


=head1 EXPORTS

The I<Serial::Core> library makes this class available by default.


=head1 SEE ALSO

=over

=item ScalarField class

=item ConstField class

=back

=cut
