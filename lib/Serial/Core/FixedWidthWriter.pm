package Serial::Core::FixedWidthWriter;
use base qw(Serial::Core::_TabularWriter);

use strict;
use warnings;


sub _join {
    # Join an array of tokens into a line of text. In this implementation the 
    # field positions don't matter; tokens must be in the correct order, and 
    # tokens must be the correct width for that field.
    my $self = shift @_;
    my ($tokens) = @_;
    return join '', @$tokens;
}

1;

__END__

=pod 

=encoding utf8


=head1 NAME

Serial::Core::FixedWidthWriter - Write fixed-width tabular data.


=head1 SYNOPSIS

    use Serial::Core;
    
    my $writer = Serial::Core::FixedWidthWriter->open($path, \@fields);
    
    $writer->filter(sub {
        my ($record) = @_;
        # Modify record as necessary.
        return $record;  # or return undef to reject this record
    });
    
    $writer->write($record);  # write a record

    $writer->dump(\@records);  # write all records


=head1 DESCRIPTION

A B<FixedWidthWriter> writes fixed-width tabular data where each field occupies
the same column in every output line. One line of input corresponds to one data 
record. 


=head1 PUBLIC METHODS

These methods define the B<FixedWidthWriter> interface.

=head2 B<new()>

Class method that returns a new B<FixedWidthWriter>.

=head3 Positional Arugments

=over

=item B<$stream>

A stream handle opened for output.

=item B<\\@fields>

An array of field objects. A field has a name, a position within each line of
input, and encoding and decoding methods, I<c.f.> L<Serial::Core::ScalarField>. 

=back

=head3 Named Options

=over

=item B<endl =E<gt> $endl>

Endline character to use when writing output lines; defaults to C<$E<sol>>.

=back

=head2 B<open()>

Class method that returns a new B<FixedWidthWriter> with automatic stream 
handling. Unlike a writer created with B<new()>, the returned object will 
automatically close its input stream when it goes out of scope.

=head3 Positional Arguments

=over

=item B<$stream>

This is either an open stream handle or a path to open as a normal text file.
In either case, the resulting stream will be closed when the reader object goes
out of scope.

=item B<\\@fields>

An array of field objects. A field has a name, a position within each line of
input, and encoding and decoding methods, I<c.f.> L<Serial::Core::ScalarField>. 

=back

=head2 B<filter()>

Add one or more filters to the writer, or call without any arguments to clear
all filters. 

=head3 Positional Arguments

=over

=item [B<\\&filter1, ...>]

A filter is any C<sub> that accepts a record as its only argument and returns 
a record (as a hashref) or C<undef> to stop the record from being written.
Records are passed through each filter in the order they were added. A record 
is dropped as soon as any filter returns C<undef>. Thus, it is more efficient 
to order filters from most to least exclusive.

=back

=head2 B<write()>

Write a filtered record to the output stream.

=head3 Positional Arguments

=over

=item B<\\%record>

The record to write. The record will be passed through all filters before being 
written.

=back

=head2 B<dump()>

Write a sequence of records to the output stream.

=head3 Positional Arguments

=over

=item B<\\@records>

An array of records to write. Each record will be passed through all filters 
before being written.

=back


=head1 SEE ALSO

=over

=item L<Serial::Core::ConstField>

=item L<Serial::Core::ScalarField> 

=item L<Serial::Core::TimeField>

=item L<Serial::Core::FieldFilter>

=item L<Serial::Core::RangeFilter>

=back

=cut
