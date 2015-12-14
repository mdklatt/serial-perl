package Serial::Core::_TabularReader;
use base qw(Serial::Core::_Reader);

use strict;
use warnings;


sub open {
    # Create a reader with automatic stream handling.
    my $class = shift @_;
    my $stream = shift @_;
    if (ref($stream) eq 'SCALAR') {
        # Assume this is a file path to open.
        open $stream, '<', $stream;
    }
    my $reader = $class->new($stream, @_);
    $reader->{_closing} = 1;
    return $reader; 
}


sub _init {
    # This is called by new() to initialize the object.
    my $self = shift @_;
    $self->SUPER::_init();
    ($self->{_stream}, $self->{_fields}, my %opts) = @_;
    $self->{_endl} = $opts{endl} || $/;
    $self->{_closing} = 0;
    return;
}


sub _get {
    # Return the next parsed record from the stream.
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


sub DESTROY {
    my $self = shift @_;
    if ($self->{_closing} && $self->{_stream}) {
        # This object has responsibility for closing the underlying stream.
        close $self->{_stream};
    }
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

The public interface includes these methods in addition to the ones inherited
from B<_Reader>.

=head2 B<open()>

Create a new reader with automatic stream handling. Unlike a reader created
with B<new()>, the returned object will automatically close its input stream
when it goes out of scope.

=head3 Positional Arguments

Any additional arguments beyond the ones listed here are passed directly to
the class-specific B<new()> method.

=over

=item B<$stream>

This is either an open stream handle or a path to open as a normal text file.
In either case, the resulting stream will be closed when the reader object goes
out of scope. The open stream is passed as the first argument to the class's
B<new()> method.

=back


=head1 PRIVATE METHODS

These methods are for implementing derived classes.

=head2 B<_init()>

This is called by C<new()> to initialize the new object. Derived classes should 
override this to do any class-specific initialization.

=head3 Positional Arguments

=over

=item B<$stream>

A stream handle opened for input.

=item B<\\@fields>

An array of field objects. A field has a name, a position within each line of
input, and encoding and decoding methods, I<c.f.> L<Serial::Core::ScalarField>. 

=back

=head3 Named Options

=over

=item B<endl=E<gt>$endl>

Endline character to use when reading input lines; defaults to C<$E<sol>>.

=back


=head2 B<_split()>

This must be implemented by derived classes to return an array of tokens for
a line of input.

=head3 Positional Arguments

=over

=item B<$line>

A line of input text.

=back


=cut
