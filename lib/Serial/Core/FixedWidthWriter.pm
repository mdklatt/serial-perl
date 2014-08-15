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

__END__

=pod 

=encoding utf8


=head1 NAME

Serial::Core::FixedWidthWriter - write fixed-width tabular data


=head1 SYNOPSIS

    use Serial::Core;

    my $writer = Serial::Core::FixedWidthWriter->new($stream, $fields);
    $writer->filter(sub {
        # Add a callback for output postprocessing.
        my ($record) = @_;
        ...
        return $record;  # or undef to drop this record
    };);
    foreach my $record (@records) {
        $writer->write($record);
    }


=head1 DESCRIPTION

A I<FixedWidthWriter> writes fixed-width tabular data where each field occupies
the same character positions in each output line. One data record corresponds 
to one line of output. 

=head2 CLASS METHODS

=over

=item new($stream, $fields, endl => $/)

Return a new I<FixedWidthWriter> object.

=back

=head3 Required Positional Arguments

=over

=item I<stream> 

A handle to the output stream, which is any object for which 
C<print $stream $line> writes an output line to the stream.

=item I<fields>

An arrayref of one or more field definitions that define the output layout.

=back

=head3 Optional Named Arguments

=over

=item I<endl>

Specify the endline character(s) to use.

=back

=head2 OBJECT METHODS

=over

=item filter([$callback1, $callback2, ...])

Add one or more filters to the writer, or without any arguments clear all
filters. Filters are applied to each outgoing record in the order they were
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

=item write($record)

Write a filtered and formatted data record to the output stream. 

=back

=head3 Required Positional Arguments

=over

=item I<record> 

The data record to write, where the record is a hashref keyed by field name.

=back

=over

=item dump($records)

Write multiple records to the output stream, eqivalent to:

    foreach my $record (@$records) {
        $writer->write($record);
    }

=back

=head3 Required Positional Arguments

=over

=item I<records> 

An arrayref of records to be written.

=back


=head1 EXPORTS

The I<Serial::Core> library makes this class available by default.


=head1 SEE ALSO

=over

=item ScalarField class

=item ConstField class

=back

=cut
