package Serial::Core::TimeField;
use base qw(Serial::Core::ScalarField);
use strict;
use warnings;

use Time::Piece;

# Convert a string token to a scalar value.
#
sub decode {
    my $self = shift @_;
    my ($token) = @_;
    $token =~ s/^\s+|\s+$//g;
    if (not $token) {
        return $self->{_default};
    }
    return Time::Piece->strptime($token, $self->{_valfmt});
}


# Convert a scalar value to a string token.
#
# Fixed-width fields are padded on the left or trimmed on the right to fit
# within the allotted field width.
#
sub encode {
    my $self = shift @_;
    my ($value) = @_;
    my $token;
    if ($value) {
        $token = $value->strftime($self->{_valfmt});        
    }
    else {
        # Use default vaulue.
        $token = $self->{_default} || '';
    }
    if ($self->{_strfmt}) {
        # Fixed-width formatting.
        $token = sprintf $self->{_strfmt}, substr($token, 0, $self->{width});
    }
    return $token;
}

# Initialize this object.
#
# A TimeField is initialized with a name, a position, and a strftime format
# string.
#
sub _init {
    # This is called by new() to do the real work when an object is created.
    my $self = shift @_;
    ($self->{name}, $self->{pos}, $self->{_valfmt}, my %opts) = @_;
    @$self{qw(_default)} = @opts{qw(default)};
    if (ref($self->{pos}) eq 'ARRAY') {
        # This is a fixed-width field; the width is in characters.
        $self->{width} = @{$self->{pos}}[1];
        $self->{_strfmt} = "%$self->{width}s";
    }
    else {
        # Integer postion; the width is 1 field.
        $self->{width} = 1;
    }
    return;
}    

1;

__END__

=pod 

=encoding utf8

=head1 NAME

Serial::Core::TimeField - define a time field


=head1 SYNOPSIS

    use Serial::Core;

    my @fields = (
        Serial::Core::TimeField->new('date', [0, 10], '%Y-%m-%d'),
        ...
    );


=head1 DESCRIPTION

A I<TimeField> maps a single input/output token to a Time::Piece field. 
I<Reader>s and I<Writer>s are initialized using a list of fields that defines
the layout of their data stream.

=head2 CLASS METHODS

=over

=item new($name, $pos, $fmt, default => undef)

Return a new I<TimeField> object.

=back

=head3 Positional Arguments (Required)

=over

=item I<name> 

Used to refer to the field in a data record, e.g. C<$record-E<gt>{$name}>.

=item I<pos>

The position of the field in the input/output line. For delimited data this is 
the field index (starting at 0), and for fixed-width data this is the substring
occupied by the field as given by its offset from 0 and total width (inclusive 
of any spacing between fields). Fixed-width fields are padded on the left or 
trimmed on the right to fit their allotted width on output.

=item I<fmt>

A strftime-compatible format string.


=back

=head3 Named Arguments (Optional)

=over

=item I<default>

Specify a default value to use for null fields. This is used on input if the 
field is blank and on output if the field is not defined in the data record.

=back

=head2 OBJECT METHODS

The object methods are used by I<Reader>s and I<Writer>s; there is no need to
access an I<TimeField> object directly.

=over

=item C<decode>

Convert a string token to a Time::Piece value. If the string is empty, the
field's default value is used.

=item C<encode>

Convert a Time::Piece value to a string token. If the value is null, the 
field's default value is encoded. For fixed-width fields, the string is padded
on the left or trimmed on he right to fit within the field.

=back

=head2 OBJECT ATTRIBUTES

The object attributes are used by I<Reader>s and I<Writer>s; there is no need 
to access a I<TimeField> object directly.

=over

=item C<name>

The field name.

=item C<pos>

The position of the field within the record, either an index or a 
(begin, length) tuple for a fixed-width field.

=back


=head1 EXPORTS

The I<Serial::Core> library makes this class available by default.

=cut
