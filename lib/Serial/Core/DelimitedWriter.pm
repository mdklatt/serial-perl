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
# If no delimiter is specified each ouput line is tab-delimited.
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

__END__

=pod 

=encoding utf8

=head1 NAME

Serial::Core::DelimitedWriter - write character-delimited tabular data

=head1 SYNOPSIS

    use Serial::Core;

    my $writer = Serial::Core::DelimitedWriter->new($stream, $fields);
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

A I<DelimitedWriter> writes character-delimited tabular data where each field
occupies the same position in each output line. One data record corresponds to
one line of output. 

=head2 CLASS METHODS

=over

=item new($stream, $fields, delim => "\t", endl => $/)

Create a new writer. The first argument is a handle to the output stream, which
is any object for which C<print $stream $line> is defined. The next argument is
an arrayref of field definitions for the output layout. The optional I<delim> 
named argument specifies the field delimiter to use; output lines are
tab-delimited by default. The optional I<endl> named argument specifies the 
endline character(s) to use; this is the system endline C<$/> by default.

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
