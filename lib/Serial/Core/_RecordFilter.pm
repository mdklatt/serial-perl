package Serial::Core::_RecordFilter;

use strict;
use warnings;

use Carp qw(croak);

use overload '&{}' => \&_func;  # make _RecordFilters callable


sub new {
    # Derived classes should not need to override this class; override _init()
    # to handle class-specific initialization.
    my $class = shift @_;
    my $self = bless {}, $class;
    $self->_init(@_);
    return $self;
}


sub _func {
    my $self = shift @_;
    return sub {
        # Define a closure to use as the filter callback.
        my ($record) = @_;
        my $match = 0;
        if (exists $record->{$self->{_field}}) {
            $match = $self->_match($record->{$self->{_field}});
        }
        return ($match xor $self->{_blacklist}) ? $record : undef;    
    };
}


sub _init {
    my $self = shift @_;
    ($self->{_field}, my %opts) = @_;
    $self->{_blacklist} = $opts{blacklist};
    return;
}


sub _match {
    # This must be implemented by derived classes to return true if the given
    # field value is a match for this filter.
    croak 'abstract method not implemented';
}


1;

__END__

=pod

=encoding utf8


=head1 NAME

Serial::Core::_RecordFilter - Abstract base class for record filters.


=head1 SYNOPSIS

    use base qw(Serial::Core::_RecordFilter);
    
    sub _init {
        my $self = shift @_;
        $self->SUPER::_init();
        # Define derived class attributes.
        return;
    }
    
    sub _match {
        my $self = shift @_;
        my ($value) = @_;
        # Test the value against the filter condition.
        return $match;
    }


=head1 DESCRIPTION

This is an abstract base class for implementing record filters. A record filter
matches a single field in a data record against a condition. The filter can act
as either a whitelist (default) or blacklist to accept or reject any matching 
records, respectively. The record is not modified. A filter can be attached to 
readers and writers using their C<filter()> method.
 

=head1 PUBLIC METHODS

All derived classes will have the following interface.

=head2 B<new()>

Class method that returns a new filter of the appropriate type.

=head2 B<&{} operator>

The class overloads B<&{}> so that it can be used as a subroutine reference.
This is used by readers and writers and normally does not need to be called in
user code.

=head3 Positional Arguments

=over

=item B<\\%record>

A data record to match.

=back

=head1 PRIVATE METHODS

These methods are for implementing derived classes.

=head2 B<_init()>

This is called by B<new()> to initialize the new object. Derived classes should 
override this to do any class-specific initialization.

=head3 Arguments

This method is called using any arguments passed to B<new()>.

=head2 B<_match()>

This must be implemented by derived classes to return true if a value matches
the filter condition.

=head3 Positional Arguments

=over

=item B<$value>

The value to test against the filter condition.

=back


=cut
