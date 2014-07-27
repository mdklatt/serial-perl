package Serial::Core::_RecordFilter;

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
        $match = $self->_match($record->{$self->{_field}});
    }
    return ($match xor $self->{_blacklist}) ? $record : undef;
}

# Initialize this object.
# 
#
sub _init {
    # This is called by new() to do the real work when an object is created.
    # Derived classes may override this as necessary.
    my $self = shift @_;
    ($self->{_field}, my %opts) = @_;
    $self->{_blacklist} = $opts{blacklist};
    return;
}

# Return true if the given field value is a match for the filter.
#
sub _match {
    # This must be implemented by child classes.
    die 'abstract method not implemented';
}

1;
