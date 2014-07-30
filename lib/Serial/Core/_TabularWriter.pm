# Abstract base class for tabular data writers.
#
# Tabular data is organize into fields such that each field occupies the same
# position in each input record. One line of text corresponds to one complete
# record.
#
package Serial::Core::_TabularWriter;
use base qw(Serial::Core::_Writer);

use strict;
use warnings;

# Initialize this object.
#
sub _init {
    my $self = shift @_;
    $self->SUPER::_init();
    ($self->{_stream}, $self->{_fields}, my %opts) = @_;
    $self->{_endl} = $opts{endl} || $/;  # default to system newline
    return;
}

# Get the next parsed record from the stream or return undef on EOF.
#
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

# Join an array of tokens into a line of text.
#
sub _join {
    # This must be implemented by child classes to return an array reference.
    die "abstract method not implemented";
}

1;
