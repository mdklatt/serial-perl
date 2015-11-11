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
    return join $self->{_delim}, @$tokens;
}


1;

__END__

=pod 

=encoding utf8


=head1 NAME

Serial::Core::DelimitedWriter - Write character-delimited tabular data.


=head1 SYNOPSIS

use Serial::Core;

my $writer = Serial::Core::DelimitedWriter->new($stream, \@fields, $endl);

$writer->filter(sub {
    my ($record) = @_;
    # Modify record as necessary.
    return $record;  # or return undef to drop record from the output sequence
});

$writer->write($record);  # write a record

$writer->dump(\@records);  # write all records


=head1 DESCRIPTION

A B<DelimitedWriter> writes character-delimited tabular data where each field
occupies the same position in every output line. One data record corresponds
to one line of output.


=head1 PUBLIC METHODS

These methods define the B<DelimitedWriter> interface.

=head2 B<new()>

Class method that returns a new B<DelimitedWriter>.

=head3 Positional Arugments

=over

=item 

B<$stream>

A stream handle opened for output.

=item

B<\@fields>

An array of field objects. A field has a name, a position within each line of
input, and encoding and decoding methods, I<c.f.> L<Serial::Core::ScalarField>. 

=item 

B<$delim>

Field delimiter to use.

=back

=head3 Named Options

=over

=item 

B<endl=E<gt>$endl>

Endline character to use when writing output lines; defaults to C<$E<sol>>.

=back

=head2 B<filter()>

Add one or more filters to the writer, or call without any arguments to clear
all filters. 

=head3 Positional Arguments

=over

=item 

[B<\&filter1, ...>]

A filter is any C<sub> that accepts a record as its only argument and returns 
a record (as a hashref) or C<undef> to drop the record from the input sequence.
Records are passed through each filter in the order they were added. A record 
is dropped as soon as any filter returns C<undef>. Thus, it is more efficient 
to order filters from most to least exclusive.

=back

=head2 B<write()>

Write a filtered record to the output stream.

=head3 Positional Arguments

=over

=item 

B<\%record>

The record to write. The record will be passed through all filters before being 
written.

=back

=head2 B<dump()>

Write a sequence of records to the output stream.

=head3 Positional Arguments

=over

=item 

B<\@records>

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
