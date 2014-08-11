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
        return $record;  # or return undef to ignore this record
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

Create a new reader. The first argument is a handle to the input stream, which
is any object for which C<E<lt>$streamE<gt>> returns a line of input. The next
argument is an arrayref of field definitions for the input layout. The optional 
I<endl> named argument specifies the endline character(s) to use; this is the 
system endline C<$/> by default.

=back

=head2 OBJECT METHODS

=over

=item filter($callback1, $callback2, ...)

Add one or more filters to the reader, or without any arguments clear all
filters. A filter is any callable object that takes a data record as its only
argument. The filter should return a data record (the original record or a
modified/new record) or C<undef> to ignore the input record. Filters are 
applied to each incoming record in the order they were added; filtering stops 
as soon as any filter in the chain returns C<undef>.

=item next()

Return the next parsed and filtered record from the input stream. Each record 
is a hash keyed by the field names. On EOF C<undef> is returned, so this can be 
used in a C<while> loop.

=item read()

Return all records from the stream as an array.

=back

=head1 EXPORTS

The I<Serial::Core> library makes this class available by default.

=cut
