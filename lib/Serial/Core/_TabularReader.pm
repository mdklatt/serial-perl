package Serial::Core::_TabularReader;
use base qw(Serial::Core::_Reader);

use strict;
use warnings;


sub _init {
    my $self = shift @_;
    $self->SUPER::_init();
    ($self->{_stream}, $self->{_fields}, my %opts) = @_;
    $self->{_endl} = $opts{endl} || $/;
    return;
}


sub _get {
    my $self = shift @_;
    local $/ = $self->{_endl};
    my $stream = $self->{_stream};  # dereference the file handle
    return undef if not (my $line = <$stream>);  # EOF
    chomp $line;
    my $tokens = $self->_split($line);
    my %record;
    foreach (0..$#{$self->{_fields}}) {
        my $field = $self->{_fields}[$_];
        $record{$field->{name}} = $field->decode($tokens->[$_]);
    }
    return \%record;
}


sub _split {
    # This must be implemented by derived classes to accept a line of input
    # text as its argument and return an arrayref of tokens.
    die "abstract method not implemented";
}

1;

__END__

=pod

=encoding utf8


=head1 NAME

Serial::Core::_TabularReader - Abstract base class for tabular data readers.


=head1 SYNOPSIS

    use base qw(Serial::Core::_TabularReader);
    
    sub _init {
        my $self = shift @_;
        $self->SUPER::_init();
        # Define derived class attributes.
        return;
    }
    
    sub _split {
        my $self = shift @_;
        (my $line) = @_; 
        # Split an input line into an array of tokens.
        return \@tokens;
    }


=head1 DESCRIPTION

This is an abstract base class for implementing tabular data readers. Tabular
data is organized into fields such that each field occupies the same position
in each record. One line of text corresponds to one complete record.

Derived classes should override the B<_init()> method as necessary, and must
implement a B<_split()> method (see L</PRIVATE METHODS>).


=head1 PUBLIC METHODS

All public methods are inherited from L<Serial::Core::_Reader>.


=head1 PRIVATE METHODS

These methods are for implementing derived classes.

=head2 B<_init()>

This is called by C<new()> to initialize the new object. Derived classes should 
override this to do any class-specific initialization.

=head3 Positional Arguments

=over

=item 

B<$stream>

A stream handle opened for input.

=item

B<\@fields>

An array of field objects. A field has a name, a position within each line of
input, and encoding and decoding methods, I<c.f.> L<Serial::Core::ScalarField>. 

=back

=head3 Named Options

=over

=item 

B<endl=E<gt>$endl>

Endline character to use when reading input lines; defaults to C<$E<sol>>.

=back


=head2 B<_split()>

This must be implemented by derived classes to return an array of tokens for
a line of input.

=head3 Positional Arguments

=over

=item

B<$line>

A line of input text.

=back


=cut
