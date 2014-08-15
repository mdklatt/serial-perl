package Serial::Core::ConstField;

use strict;
use warnings;


# Create a new object.
#
sub new {
    # Derived classes should not need to override this class; override _init()
    # to handle class-specific initialization.
    my $class = shift @_;
    my $self = bless {}, $class;
    $self->_init(@_);
    return $self;
}

# Return a constant value.
#
sub decode {
    my $self = shift @_;
    return $self->{_value};
}

# Return a constant token.
#
# Fixed-width fields are padded on the left or trimmed on the right to fit
# within the allotted field width.
#
sub encode {
    my $self = shift @_;
    return $self->{_token};
}

# Initialize this object.
#
sub _init {
    # This is called by new() to do the real work when an object is created.
    # Derived classes may override this as necessary.
    my $self = shift @_;
    ($self->{name}, $self->{pos}, $self->{_value}, my %opts) = @_;
    my $valfmt = $opts{fmt} or '%s';
    my $token = sprintf $valfmt, $self->{_value};
    if (ref($self->{pos}) eq 'ARRAY') {
        # This is a fixed-width field; the width is in characters.
        $self->{width} = @{$self->{pos}}[1];
        $token = sprintf "%$self->{width}s", substr($token, 0, $self->{width});
    }
    else {
        # Integer postion; the width is 1 field.
        $self->{width} = 1;
    }
    $self->{_token} = $token;
    return;
}    

1;

__END__

=pod 

=encoding utf8

=head1 NAME

Serial::Core::ConstField - define a constant value field


=head1 SYNOPSIS

    use Serial::Core;

    my @fields = (
        Serial::Core::ConstField->new($name, $pos, $value),
        ...
    );
    my $reader = new Serial::Core::DelimitedReader($stream, \@fields);

    my @fields = (
        Serial::Core::ConstField->new($name, [$beg, $len], $value),
        ...
    );
    my $reader = new Serial::Core::FixedWidthReader($stream, \@fields);


=head1 DESCRIPTION

A I<ConstField> maps a constant input/output value to a data field. I<Reader>s
and I<Writer>s are initialized using a list of fields that defines the layout
of their data stream.

=head2 CLASS METHODS

=over

=item new($name, $pos, $value, fmt => '%s')

Return a new I<ConstField> object.

=back

=head3 Required Positional Arguments

=over

=item I<name> 

Used to refer to the field in a data record, e.g. C<$record-E<gt>{$name}>.

=item I<pos>

The position of the field in the input/output line. For delimited data this is the field 
index (starting at 0), and for fixed-width data this is the substring occupied 
by the field as given by its offset from 0 and total width (inclusive of any 
spacing between fields). Fixed-width fields are padded on the left or trimmed 
on the right to fit their allotted width on output.

=item I<value>

The constant value for this field.

=back

=head3 Optional Named Arguments

=over

=item I<fmt>

A C<printf()> format string that is used by a I<Writer> for formatted output
(it has no effect on input). Specifying a format width is optional, but for
fixed-width fields a format width smaller than the field width can be used to
control spacing between fields. 

=back


=head2 OBJECT METHODS

The object methods are used by I<Reader>s and I<Writer>s; there is no need to
access a I<ConstField> object directly.

=head2 OBJECT ATTRIBUTES

The object attributes are used by I<Reader>s and I<Writer>s; there is no need 
to access a I<ConstField> object directly.


=head1 EXPORTS

The I<Serial::Core> library makes this class available by default.

=cut
