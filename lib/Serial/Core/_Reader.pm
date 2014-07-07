# Abstract base class for all reader types.
#
# Readers convert lines of text to data records.
#
package Serial::Core::_Reader;

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
    $class ne __PACKAGE__ or die "${class} is an abstract class";
    my $self = bless({}, $class);
    $self->_init(@_);
    return $self;
}

# Add one or more filters to the reader.
#
# A filter is a sub that takes a record (as a hash reference) as its only
# argument and returns that record (potentially modified) or undef to ignore 
# the record.
#
sub filter {
    # This does not effect class filters.
    my ($self, @callbacks) = @_;
    if (@callbacks) {
        push @{$self->{_user_filters}}, @callbacks;    
    }
    else {
        $self->{_user_filters} = [];    
    }
    return;
}

# Read the next filtered record from the stream. 
#
# This returns undef on EOF so it can be used in a while loop.
#
sub read {
    my ($self) = @_;
    while (my $record = $self->_get()) {
        # Continue until a valid record is found or EOF. This would be
        # simplified by recursion, but recursion could not handle a large
        # number of invalid records.
        foreach (@{$self->{_filters}}) {
            # Apply each filter in order. Stop as soon as the record fails a
            # filter and try the next record.
            $record = $_->($record);
            last if !$record;
        }
        return (wantarray ? %$record : $record) if $record;
    }
    return;  # EOF
}

# Read all records into a list.
sub all {
    my ($self) = @_;
    my @records;
    while (my $record = $self->read()) {
        push @records, $record;
    }
    return wantarray ? @records : \@records;
}

# Initialize this object.
#
# This is called by new() to do the real work when an object is created.
# Derived classes may override this as necessary, but must make sure to call it
# to initialize the base class, e.g. SUPER::_init()
#
sub _init {
    # Class filters are always applied before any user filters. Derived classes
    # can use these to do any preliminary data manipulation after the record is
    # parsed.
    my ($self) = @_;
    $self->{_class_filters} = [];
    $self->{_user_filters} = [];
    return;
}

# Get the next parsed record from the stream.
#
sub _get {
    # This must be implemented by child classes to return a reference to a hash
    # consisting of data values keyed by their field names.
    die "abstract method ${\(caller(0))[3]} not implemented";
}

1;
