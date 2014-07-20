package Serial::Core::FieldFilter;

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
        $match = $self->{_values}{$value};
    }
    return ($match xor $self->{_blacklist}) ? $record : undef;
}

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
    ($self->{_field}, my $values, my %opts) = @_;
    $self->{_values} = {map { $_ => 1 } @$values};  # pseudo set
    $self->{_blacklist} = $opts{blacklist};
    return;
}

1;
