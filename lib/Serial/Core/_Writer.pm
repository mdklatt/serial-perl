package Serial::Core::_Writer;

use strict;
use warnings;

use Carp qw(croak); 


sub new {
    # Derived classes should not need to override this class; override _init()
    # to handle class-specific initialization.
    my $class = shift @_;
    my $self = bless({}, $class);
    $self->_init(@_);
    return $self;
}


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


sub dump {
    my $self = shift @_;
    my ($records) = @_;
    foreach my $record (@$records) {
        $self->write($record);
    }
    return;
}


sub _init {
    # Class filters are always applied before any user filters. Derived classes
    # can use these to do any preliminary data manipulation after the record is
    # parsed.
    my $self = shift @_;
    $self->{_class_filters} = [];
    $self->{_user_filters} = [];
    return;
}


sub _put {
    # Write a single record to output. This is called after the record has been
    # passed through all filters.
    croak "abstract method not implemented";
}

1;

__END__

=pod

=encoding utf8


=head1 NAME

Serial::Core::_Writer - Abstract base class for serial data writers.


=head1 SYNOPSIS

    use base qw(Serial::Core::_Writer);
    
    sub _init {
        my $self = shift @_;
        $self->SUPER::_init();
        # Define derived class attributes.
        return;
    }
    
    sub _put {
        my $self = shift @_;
        my ($record) = @_;
        # Write a formatted record to the output stream.
        return;
    }


=head1 DESCRIPTION

This is an abstract base class for implementing serial data writers. A writer
converts records consisting of named data fields to sequential output, I<e.g.>
lines of text. Output can be passed through one or more filters to modify 
and/or reject each record.

Derived classes should override the B<_init()> method as necessary, and must
implement a B<_put()> method (see L</PRIVATE METHODS>).


=head1 PUBLIC METHODS

All derived classes will have the following interface.

=head2 B<new()>

Class method that returns a new reader of the appropriate type.

=head2 B<filter()>

Add one or more filters to the writer, or call without any arguments to clear
all filters. 

=head3 Positional Arguments

=over

=item 

[B<\&filter1, ...>]

A filter is any C<sub> that accepts a record as its only argument and returns 
a record (as a hashref) or C<undef> to drop the record from the input sequence.
Records are passed through each filter in the order they were added. A record 
is dropped as soon as any filter returns C<undef>. Thus, it is more efficient 
to order filters from most to least exclusive.

=back

=head2 B<write()>

Write a filtered record to the output stream.

=head3 Positional Arguments

=over

=item 

B<\%record>

The record to write. The record will be passed through all filters before being 
written.

=back

=head2 B<dump()>

Write a sequence of records to the output stream.

=head3 Positional Arguments

=over

=item 

B<\%record1, ...>

One or more records to write. Each record will be passed through all filters 
before being written.

=back


=head1 PRIVATE METHODS

These methods are for implementing derived classes.

=head2 B<_init()>

This is called by B<new()> to initialize the new object. Derived classes should 
override this to do any class-specific initialization.

=head3 Arguments

This method is called using any arguments passed to B<new()>.

=head2 B<_put()>

This must be implemented by derived classes to format a record and write it to
the output stream.

=head3 Positional Arguments

=over

=item 

B<\%record>

The record to write.

=back


=cut
