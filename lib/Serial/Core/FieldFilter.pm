package Serial::Core::FieldFilter;
use base qw(Serial::Core::_RecordFilter);
use strict;
use warnings;


sub _init {
    # This is called by new() to do the real work when an object is created.
    # Derived classes may override this as necessary.
    my $self = shift @_;
    my ($field, $values, %opts) = @_;
    $self->SUPER::_init($field, %opts);
    $self->{_values} = {map { $_ => 1 } @$values};  # pseudo set
    return;
}


sub _match {
    my $self = shift @_;
    my ($value) = @_;
    return $self->{_values}{$value};
}


1;

__END__

=pod 

=encoding utf8


=head1 NAME

Serial::Core::FieldFilter - Filter a data field against a set of values.


=head1 SYNOPSIS

    use Serial::Core;
    
    my @values = ('foo', 'bar');
    my $reader = Serial::Core::FixedWidthReader->new($stream, \@fields);
    $reader->filter(Serial::Core::FieldFilter->new('field', \@values));


=head1 DESCRIPTION

A B<FieldFilter> filters a record by matching a data field against a set of
values. The filter can act as either a whitelist (default) or blacklist to 
accept or reject any matching records, respectively. The record is not 
modified. A filter can be attached to readers and writers using their 
C<filter()> method.


=head1 PUBLIC METHODS

These methods define the B<FieldFilter> interface.

=head2 B<new()>

Class method that returns a new B<FieldFilter>.

=head3 Positional Arugments

=over

=item 

B<$field>

The data field name to use with this filter.

=item

B<\@values>

An array of values to match against. 

=back

=head3 Named Options

=over

=item 

B<blacklist=E<gt>$blacklist>

Boolean value to control blacklisting; defaults to false.

=back

=head2 B<&{} operator>

The class overloads B<&{}> so that it can be used as a subroutine reference.
This is used by readers and writers and normally does not need to be called in
user code.


=head1 SEE ALSO

=over

=item L<Serial::Core::RangeFilter>

=item L<Serial::Core::DelimitedReader>

=item L<Serial::Core::DelimitedWriter>

=item L<Serial::Core::FixedWidthReader>

=item L<Serial::Core::FixedWidthWriter>

=back

=cut
