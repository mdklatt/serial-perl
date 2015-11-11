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

Serial::Core::FixedWidthReader - Read fixed-width tabular data.


=head1 SYNOPSIS

    use Serial::Core;
    
    my $reader = Serial::Core::FixedWidthReader->new($stream, \@fields);
    
    $reader->filter(sub {
        my ($record) = @_;
        # Modify record as necessary.
        return $record;  # or return undef to drop record from the input sequence
    });
    
    while (my $record = $reader->next()) {
        # Process each record.
    }
    
    my @records = $reader->read(count=>10);  # read at most 10 records


=head1 DESCRIPTION

A B<FixedWidthReader> reads fixed-width tabular data where each field occupies
the same column in every input line. One line of input corresponds to one data 
record. 


=head1 PUBLIC METHODS

These methods define the B<FixedWidthReader> interface.

=head2 B<new()>

Class method that returns a new B<FixedWidthReader>.

=head3 Positional Arugments

=over

=item 

B<$stream>

A stream handle opened for input.

=item

B<\@fields>

An array of field objects. A field has a name, a position within each line of
input, and encoding and decoding methods, I<c.f.> L<Serial::Core::ScalarField>. 

=back

=head3 Named Options

=over

=item 

B<endl =E<gt> $endl>

Endline character to use when reading input lines; defaults to C<$E<sol>>.

=back

=head2 B<filter()>

Add one or more filters to the reader, or call without any arguments to clear
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

=head2 B<next()>

Return the next filtered input record or C<undef> on EOF.

=head2 B<read()>

Return all filtered input records as an array.

=head3 Named Options

=over

=item 

B<count =E<gt> $count>

Return B<$count> records at most.

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
