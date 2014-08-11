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
        return $record;  # or return undef to ignore this record
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

Create a new writer. The first argument is a handle to the output stream, which
is any object for which C<print $stream $line> is defined. The optional I<endl>
named argument specifies the endline character(s) to use; this is the system 
endline C<$/> by default.

=back

=head2 OBJECT METHODS

=over

=item filter($callback1, $callback2, ...)

Add one or more filters to the writer, or without any arguments clear all
filters. A filter is any callable object that takes a data record as its only
argument. The filter should return a data record (the original record or a
modified/new record) or C<undef> to ignore the output record. Filters are 
applied to each outgoing record in the order they were added; filtering stops 
as soon as any filter in the chain returns C<undef>.

=item write($record)

Write a filtered and formatted data record to the output stream. 

=item dump($records)

Write an array of records to the output stream. This is equivalent to:

    foreach my $record (@$records) {
        $writer->write($record);
    }

=back

=head1 EXPORTS

The I<Serial::Core> library makes this class available by default.

=cut
