package Serial::Core::_TabularWriter;
use base qw(Serial::Core::_Writer);

use strict;
use warnings;

use Carp qw(croak);


sub open {
    # Create a writer with automatic stream handling.
    my $class = shift @_;
    my $stream = shift @_;
    if (ref($stream) eq 'SCALAR') {
        # Assume this is a file path to open.
        open $stream, '>', $stream;
    }
    my $writer = $class->new($stream, @_);
    $writer->{_closing} = 1;
    return $writer; 
}


sub _init {
    my $self = shift @_;
    $self->SUPER::_init();
    ($self->{_stream}, $self->{_fields}, my %opts) = @_;
    $self->{_endl} = $opts{endl} || $/;  # default to system newline
    $self->{_closing} = 0;
    return;
}


sub _put {
    my $self = shift @_;
    my ($record) = @_;
    my @tokens;
    foreach my $field (@{$self->{_fields}}) {
        my $value = $record->{$field->{name}};
        push @tokens, $field->encode($value);
    }
    my $stream = $self->{_stream};  # dereference the file handle
    print $stream $self->_join(\@tokens).$self->{_endl};
    return;
}


sub _join {
    # This must be implemented by child classes to return a line of text.
    croak "abstract method not implemented";
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

Serial::Core::_TabularWriter - Abstract base class for tabular data writers.


=head1 SYNOPSIS

    use base qw(Serial::Core::_TabularWriter);
    
    sub _init {
        my $self = shift @_;
        $self->SUPER::_init();
        # Define derived class attributes.
        return;
    }
    
    sub _join {
        my $self = shift @_;
        my ($tokens) = @_;
        # Join tokens into a line of output.
        return $line;
    }


=head1 DESCRIPTION

This is an abstract base class for implementing tabular data writers. Tabular
data is organized into fields such that each field occupies the same position
in each record. One line of text corresponds to one complete record.

Derived classes should override the B<_init()> method as necessary, and must
implement a B<_join()> method (see L</PRIVATE METHODS>).


=head1 PUBLIC METHODS

All public methods are inherited from L<Serial::Core::_Writer>.


=head1 PRIVATE METHODS

These methods are for implementing derived classes.

=head2 B<_init()>

This is called by C<new()> to initialize the new object. Derived classes should 
override this to do any class-specific initialization.

=head3 Positional Arguments

=over

=item B<$stream>

A stream handle opened for output.

=item B<\\@fields>

An array of field objects. A field has a name, a position within each line of
input, and encoding and decoding methods, I<c.f.> L<Serial::Core::ScalarField>. 

=back

=head3 Named Options

=over

=item B<endl=E<gt>$endl>

Endline character to use when writing output lines; defaults to C<$E<sol>>.

=back

=head2 B<_join()>

This must be implemented by derived classes to join an array of tokens into a
single line of text.

=head3 Positional Arguments

=over

=item B<\\@tokens>

An array of formatted text tokens.

=back


=cut
