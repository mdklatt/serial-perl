package Serial::Core::RangeFilter;
use parent qw(Serial::Core::_RecordFilter);

use strict;
use warnings;


# Initialize this object.
#
# A RangeFilter is initialized with a field, an array of values, and an
# optional 'blacklist' keyword argument that controls if this is a blacklist
# or a whitelist (default is whitelist).
#
sub _init {
    # This is called by new() to do the real work when an object is created.
    # Derived classes may override this as necessary.
    my $self = shift @_;
    my ($field, $range, %opts) = @_;
    $self->SUPER::_init($field, %opts);
    ($self->{_min}, $self->{_max}) = @$range;
    return;
}

sub _match {
    my $self = shift @_;
    my ($value) = @_;
    return (!defined($self->{_min}) || $self->{_min} <= $value) &&
           (!defined($self->{_max}) || $self->{_max} >= $value);
}

1;
