package Serial::Core::ScalarField;

use strict;
use warnings;


# Create a new object.
#
# See _init() for an argument description.
#
sub new {
    # Derived classes should not need to override this class; override _init()
    # to handle class-specific initialization.
    my ($class) = shift @_;
    my $self = bless {}, $class;
    $self->_init(@_);
    return $self;
}

# Convert a string token to a scalar value.
#
sub decode {
    my ($self, $token) = @_;
    $token =~ s/^\s+|\s+$//g;  # strip leading/trailing whitespace
    return $token eq '' ? $self->{_default} : $token
}


# Convert a scalar value to a string token.
#
# Fixed-width fields are padded on the left or trimmed on the right to fit
# within the allotted field width.
#
sub encode {
    my ($self, $value) = @_;
    if ($self->{_valfmt}) {
        $value = sprintf($self->{_valfmt});
    }
    if ($self->{_strfmt}) {
        $value = sprintf $self->{_strfmt}, substr($value, 0, $self->{width});
    }
    return $value;
}


# Initialize this object.
#
# A ScalarField is initialized with a name, a position, and an optional sprintf
# format string.
#
sub _init {
    # This is called by new() to do the real work when an object is created.
    # Derived classes may override this as necessary.
    my $self = shift @_;
    ($self->{name}, $self->{pos}, $self->{_valfmt}) = @_;
    if (ref($self->{pos}) eq 'ARRAY') {
        # This is a fixed-width field; the width is in characters.
        $self->{width} = @{$self->{pos}}[1];
        $self->{_strfmt} = "%$self->{width}s";
    }
    else {
        # Integer postion; the width is 1 field.
        $self->{width} = 1;
    }
    $self->{_default} = undef;  # TODO: user argument
    return;
}    


1;
