package Serial::Core::RangeFilter;

use strict;
use warnings;


# Create a new object.
#
# See _init() for an argument description.
#
sub new {
    # Derived classes should not need to override this class; override _init()
    # to handle class-specific initialization.
    my $class = shift @_;
    my $self = bless {}, $class;
    $self->_init(@_);
    return $self;
}

# Execute the filter.
#
sub call {
    my $self = shift @_;
    my ($record) = @_;
    my $match = 0;
    if (exists $record->{$self->{_field}}) {
        my $value = $record->{$self->{_field}};
        $match = (!defined($self->{_min}) || $self->{_min} <= $value) &&
                 (!defined($self->{_max}) || $self->{_max} >= $value);
    }
    return ($match xor $self->{_blacklist}) ? $record : undef;
}

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
    ($self->{_field}, my $range, my %opts) = @_;
    ($self->{_min}, $self->{_max}) = @$range;
    $self->{_blacklist} = $opts{blacklist};
    return;
}

1;
