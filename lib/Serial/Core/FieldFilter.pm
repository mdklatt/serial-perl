package Serial::Core::FieldFilter;
use parent qw(Serial::Core::_RecordFilter);
use strict;
use warnings;

# Initialize this object.
#
# A FieldFilter is initialized with a field, an array of values, and an
# optional 'blacklist' keyword argument that controls if this is a blacklist
# or a whitelist (default is whitelist).
#
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
