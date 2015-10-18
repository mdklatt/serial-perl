package Serial::Core::ScalarField;

use strict;
use warnings;


## Create a new object.
##
## See _init() for an argument description.
##
sub new {
    # Derived classes should not need to override this class; override _init()
    # to handle class-specific initialization.
    my $class = shift @_;
    my $self = bless {}, $class;
    $self->_init(@_);
    return $self;
}

## Convert a string token to a scalar value.
##
sub decode {
    my $self = shift @_;
    my ($token) = @_;
    $token =~ s/^\s+|\s+$//g;
    if ($self->{_quote}) {
        my $quote = qr/$self->{_quote}/;    
        $token =~ s/^$quote+|$quote+$//g;    
    }
    return $token eq '' ? $self->{_default} : $token
}

## Convert a scalar value to a string token.
##
## Fixed-width fields are padded on the left or trimmed on the right to fit
## within the allotted field width.
##
sub encode {
    my $self = shift @_;
    my ($value) = @_;
    $value ||= $self->{_default} || '';
    if ($self->{_valfmt}) {
        $value = sprintf($self->{_valfmt}, $value);
    }
    if ($self->{_quote}) {
        $value = $self->{_quote}.$value.$self->{_quote};
    }
    if ($self->{_strfmt}) {
        # Fixed-width formatting.
        $value = sprintf $self->{_strfmt}, substr($value, 0, $self->{width});
    }
    return $value;
}

## Initialize this object.
##
## A ScalarField is initialized with a name, a position, and an optional 
## sprintf format string.
##
sub _init {
    # This is called by new() to do the real work when an object is created.
    # Derived classes may override this as necessary.
    my $self = shift @_;
    ($self->{name}, $self->{pos}, my %opts) = @_;
    @$self{qw(_valfmt _default _quote)} = @opts{qw(fmt default quote)};
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

Serial::Core::ScalarField - define a scalar data field


=head1 SYNOPSIS

    use Serial::Core;

    my @fields = (
        Serial::Core::ScalarField->new($name, $pos),
        ...
    );
    my $reader = new Serial::Core::DelimitedReader($stream, \@fields);

    my @fields = (
        Serial::Core::ScalarField->new($name, [$beg, $len]),
        ...
    );
    my $reader = new Serial::Core::FixedWidthReader($stream, \@fields);


=head1 DESCRIPTION

A I<ScalarField> maps a single input/output token to a data field. I<Reader>s
and I<Writer>s are initialized using a list of fields that defines the layout
of their data stream.

=head2 CLASS METHODS

=over

=item new($name, $pos, fmt => '%s', quote => '', default => undef)

Return a new I<ScalarField> object.

=back

=head3 Required Positional Arguments

=over

=item I<name> 

Used to refer to the field in a data record, e.g. C<$record-E<gt>{$name}>.

=item I<pos>

The position of the field in the input/output line. For delimited data this is 
the field index (starting at 0), and for fixed-width data this is the substring 
occupied by the field as given by its offset from 0 and total width (inclusive 
of any spacing between fields). Fixed-width fields are padded on the left or 
trimmed on the right to fit their allotted width on output.

=back

=head3 Optional Named Arguments

=over

=item I<fmt>

A C<printf()> format string that is used by a I<Writer> for formatted output
(it has no effect on input). Specifying a format width is optional, but for
fixed-width fields a format width smaller than the field width can be used to
control spacing between fields. 

=item I<quote>

Specify a I<quote> character to strip input of leading/trailing quotes and to 
automatically quote output. 

=item I<default>

Specify a default value to use for null fields. This is used on input if the 
field is blank and on output if the field is not defined in the data record.

=back

=head2 OBJECT METHODS

The object methods are used by I<Reader>s and I<Writer>s; there is no need to
access a I<ScalarField> object directly.

=head2 OBJECT ATTRIBUTES

The object attributes are used by I<Reader>s and I<Writer>s; there is no need 
to access a I<ScalarField> object directly.


=head1 EXPORTS

The I<Serial::Core> library makes this class available by default.

=cut
