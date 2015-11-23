package Serial::Core::RangeFilter;
use base qw(Serial::Core::_RecordFilter);

use strict;
use warnings;




sub _init {
    # This is called by new() to do the real work when an object is created.
    # Derived classes may override this as necessary.
    # TODO: Change min and max to seperate optional arguments.
    my $self = shift @_;
    my ($field, %opts) = @_;
    $self->SUPER::_init($field, %opts);
    @$self{qw(_min _max)} = @opts{qw(min max)};
    return;
}


sub _match {
    my $self = shift @_;
    my ($value) = @_;
    return (!defined($self->{_min}) || $self->{_min} <= $value) &&
           (!defined($self->{_max}) || $self->{_max} >= $value);
}


1;

__END__

=pod 

=encoding utf8


=head1 NAME

Serial::Core::RangeFilter - Filter a data field against a numeric range.


=head1 SYNOPSIS

    use Serial::Core;
    
    my $reader = Serial::Core::FixedWidthReader->new($stream, \@fields);
    $reader->filter(Serial::Core::RangeFilter->new('field', min=>0, max=>5));


=head1 DESCRIPTION

A B<RangeFilter> filters a record by matching a data field against the numeric
range [min, max]. The filter can act as either a whitelist (default) or 
blacklist to accept or reject any matching records, respectively. The record is 
not modified. A filter can be attached to readers and writers using their 
C<filter()> method.


=head1 PUBLIC METHODS

These methods define the B<RangeFilter> interface.

=head2 B<new()>

Class method that returns a new B<RangeFilter>.

=head3 Positional Arugments

=over

=item B<$field>

The data field name to use with this filter.

=back

=head3 Named Options

=over

=item B<min=E<gt>$min>

Minimum (inclusive) of the range to match; defaults to C<undef>, in which case
the range is unbounded in this direction.

=item B<max=E<gt>$max>

Maximum (inclusive) of the range to match; defaults to C<undef>, in which case
the range is unbounded in this direction.

=item B<blacklist=E<gt>$blacklist>

Boolean value to control blacklisting; defaults to false.

=back

=head2 B<&{} operator>

The class overloads B<&{}> so that it can be used as a subroutine reference.
This is used by readers and writers and normally does not need to be called in
user code.


=head1 SEE ALSO

=over

=item L<Serial::Core::FieldFilter>

=item L<Serial::Core::DelimitedReader>

=item L<Serial::Core::DelimitedWriter>

=item L<Serial::Core::FixedWidthReader>

=item L<Serial::Core::FixedWidthWriter>

=back

=cut
