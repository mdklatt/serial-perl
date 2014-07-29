package Serial::Core::_RecordFilter;

use strict;
use warnings;

use overload '&{}' => \&_func;  # make _RecordFilters callable


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

# Return a filter function for this object.
#
# This is assigned to the & dereference operator so that the object can be used 
# as a callaback.
#
sub _func {
    my $self = shift @_;
    return sub {
        my ($record) = @_;
        my $match = 0;
        if (exists $record->{$self->{_field}}) {
            $match = $self->_match($record->{$self->{_field}});
        }
        return ($match xor $self->{_blacklist}) ? $record : undef;    
    };
}



# Initialize this object.
#
# This is called by new() to do the real work when an object is created.
# Derived classes may override this as necessary.
# 
sub _init {
    my $self = shift @_;
    ($self->{_field}, my %opts) = @_;
    $self->{_blacklist} = $opts{blacklist};
    return;
}

# Return true if the given field value is a match for the filter.
#
# This must be implemented by derived classes.
#
sub _match {
    die 'abstract method not implemented';
}

1;
