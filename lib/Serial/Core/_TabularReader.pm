# Abstract base class for tabular data readers.
#
# Tabular data is organize into fields such that each field occupies the same
# position in each input record. One line of text corresponds to one complete
# record.
#
package Serial::Core::_TabularReader;
use base qw(Serial::Core::_Reader);

use strict;
use warnings;

# Initialize this object.
#
sub _init {
    my $self = shift @_;
    $self->SUPER::_init();
    ($self->{_stream}, $self->{_fields}) = @_;
    my %opts = @_[2..$#_];
    $self->{_endl} = $opts{endl} || $/;  # default to system newline
    return;
}

# Get the next parsed record from the stream or return undef on EOF.
#
sub _get {
    my $self = shift @_;
    local $/ = $self->{_endl};
    my $stream = $self->{_stream};  # dereference the file handle
    return if !(my $line = <$stream>);
    chomp $line;
    my $tokens = $self->_split($line);
    return {map { 
        $_->{name} => $_->decode($tokens->[$_->{pos}]) 
    } @{$self->{_fields}}};
}

# Split a line of text into an array of tokens.
#
sub _split {
    # This must be implemented by child classes to return an array reference.
    die "abstract method ${\(caller(0))[3]} not implemented";
}

1;
