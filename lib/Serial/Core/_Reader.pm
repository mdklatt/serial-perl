package Serial::Core::_Reader;

use strict;
use warnings;

use Carp qw(croak); 


sub new {
    # Derived classes should override _init() to handle class-specific 
    # initialization.
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


sub next {
    # Each record is passed through the reader's class filters and then any
    # user filters added by filter().
    my $self = shift @_;
    my @callbacks = (@{$self->{_class_filters}}, @{$self->{_user_filters}});
    while (my $record = $self->_get()) {
        # Continue until a valid record is found or EOF. 
        foreach (@callbacks) {
            # Apply each filter in order. Stop as soon as the record fails a
            # filter and try the next record.
            last if not defined($record = $_->($record));
        }
        return (wantarray ? %$record : $record) if $record;
    }
    return undef;  # EOF
}


sub read {
    my $self = shift @_;
    my (%opts) = @_;
    my $count = $opts{count};
    my @records;
    while (my $record = $self->next()) {
        push @records, $record;
        last if defined($count) && scalar(@records) == $count;
    }
    return wantarray ? @records : \@records;
}


sub _init {
    # Deverived classes should override this to initialize the object after it
    # has been created by new(). Use SUPER::_init() to make sure the base class
    # is initialized.
    my $self = shift @_;
    $self->{_class_filters} = [];
    $self->{_user_filters} = [];
    return;
}


sub _get {
    # This must be implemented by derived classes to return a hashref 
    # consisting of data values keyed by their field names.
    croak "abstract method not implemented";
}

1;  

__END__

=pod

=encoding utf8


=head1 NAME

Serial::Core::_Reader - Abstract base class for serial data readers.


=head1 SYNOPSIS

    use base qw(Serial::Core::_Reader);
    
    sub _init {
        my $self = shift @_;
        $self->SUPER::_init();
        # Define derived class attributes.
        return;
    }
    
    sub _get {
        my $self = shift @_;
        # Get the next record from the stream.
        return \%record;
    }


=head1 DESCRIPTION

This is an abstract base class for implementing serial data readers. A reader 
converts sequential input, I<e.g.> lines of text, to records consisting of 
named data fields. Input can be passed through one or more filters to modify 
and/or reject each record.

Derived classes should override the B<_init()> method as necessary, and must
implement a B<_get()> method (see L</PRIVATE METHODS>).


=head1 PUBLIC METHODS

All derived classes will have the following interface.

=head2 B<new()>

Class method that returns a new reader of the appropriate type.

=head2 B<filter()>

Add one or more filters to the reader, or call without any arguments to clear
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

=head2 B<next()>

Return the next filtered input record or C<undef> on EOF.

=head2 B<read()>

Return all filtered input records as an array.

=head3 Named Options

=over

=item 

B<count=E<gt>$count>

Return B<$count> records at most.

=back


=head1 PRIVATE METHODS

These methods are for implementing derived classes.

=head2 B<_init()>

This is called by B<new()> to initialize the new object. Derived classes should 
override this to do any class-specific initialization.

=head3 Arguments

This method is called using any arguments passed to B<new()>.

=head2 B<_get()>

This must be implemented by derived classes to return the next parsed input
record or C<undef> on EOF.


=cut
