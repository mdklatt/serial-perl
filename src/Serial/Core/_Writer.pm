# Abstract base class for all writer types.
#
# Writers convert data records to lines of text.
#
package Serial::Core::_Writer;

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
    $class ne __PACKAGE__ or die "${class} is an abstract class";
    my $self = bless({}, $class);
    $self->_init(@_);
    return $self;
}

# Add one or more filters to the writer.
#
# A filter is a sub that takes a record (as a hash reference) as its only
# argument and returns that record (potentially modified) or undef to ignore 
# the record.
#
sub filter {
    # This does not affect class filters.
    my $self = shift @_;
    if (@_) {
        push @{$self->{_user_filters}}, @_;    
    }
    else {
        $self->{_user_filters} = [];    
    }
    return;
}

# Write the next filtered record to the output stream. 
#
sub write {
    my $self = shift @_;
    my ($record) = @_;
    my $callbacks = [@{$self->{_user_filters}}, @{$self->{_class_filters}}];
    foreach (@{$callbacks}) {
        if (!defined($record = $_->($record))) {
            return;
        }
    }
    $self->_put($record);
    return;
}

# Write records to the stream.
#
sub dump {
    my $self = shift @_;
    my ($records) = @_;
    foreach my $record (@$records) {
        $self->write($record);
    }
    return;
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
    my $self = shift @_;
    $self->{_class_filters} = [];
    $self->{_user_filters} = [];
    return;
}

# Put a formatted record into the output stream.
#
# This must be implemented by child classes to accept a data record as a hash
# reference and write it to the output stream.
#
sub _put {
    die "abstract method ${\(caller(0))[3]} not implemented";
}

1;
