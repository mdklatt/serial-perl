package Serial::Core::RangeFilter;
use base qw(Serial::Core::_RecordFilter);

use strict;
use warnings;


# Initialize this object.
#
# A RangeFilter is initialized with a field, a [min, max] numerical range, and
# an optional 'blacklist' named argument that controls if this is a blacklist
# or a whitelist (default is whitelist).
#
sub _init {
    # This is called by new() to do the real work when an object is created.
    # Derived classes may override this as necessary.
    my $self = shift @_;
    my ($field, $range, %opts) = @_;
    $self->SUPER::_init($field, %opts);
    @$self{qw(_min _max)} = @$range;
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

Serial::Core::RangeFilter - filter records using a numerical range

=head1 SYNOPSIS

    use Serial::Core;

    my $whitelist = new Serial::Core::RangeFilter($field, [$min, $max]);
    $reader->filter($whitelist);


=head1 DESCRIPTION

A I<RangeFilter> is intended for use with the C<filter()> method of a I<Reader>
or I<Writer>. The given field is matched against the numerical range 
[min, max]. Matching records can be whitelisted or blacklisted.

=head2 CLASS METHODS

=over

=item new($field, $range, blacklist => 0)

Create a new filter. The first argument is the name of the field to match. The
next argument is the numerical range [min, max]; if min or max is C<undef> the
range is unlimited in that direction. Set the optional named boolean argument 
I<blacklist> to true for blacklisting; whitelisting is the default behavior.

=back

=head2 OBJECT METHODS

The object methods are used by I<Reader>s and I<Writer>s; there is no need to
access a I<RangeFilter> object directly.


=head1 EXPORTS

The I<Serial::Core> library makes this class available by default.

=cut
