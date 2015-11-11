package Serial::Core::ScalarField;

use strict;
use warnings;


sub new {
    # Derived classes should not need to override this class; override _init()
    # to handle class-specific initialization.
    my $class = shift @_;
    my $self = bless {}, $class;
    $self->_init(@_);
    return $self;
}


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
        # Fixed-width formatting. The value is padded on the left or trimmed on
        # on the right to fit the alotted width. 
        $value = sprintf $self->{_strfmt}, substr($value, 0, $self->{width});
    }
    return $value;
}


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

Serial::Core::ConstField - Define a scalar field.


=head1 SYNOPSIS

    use Serial::Core;

    my @fields = (
        # Delimited fields have an index position.
        Serial::Core::ScalarField->new($name, $pos),
        ...
    );
    my $reader = new Serial::Core::DelimitedReader($stream, \@fields);
    my $writer = new Serial::Core::DelimitedWriter($stream, \@fields, ',');

    my @fields = (
        # Fixed-width fields have a substring position.
        Serial::Core::ScalarField->new($name, [$beg, $len]),
        ...
    );
    my $reader = new Serial::Core::FixedWidthReader($stream, \@fields);
    my $writer = new Serial::Core::FixedWidthWriter($stream, \@fields);


=head1 DESCRIPTION

Readers and writers are initialized using a list of fields that defines the 
layout of their data stream. A B<ScalarField> maps a scalar value (I<e.g.> a 
string or a number) to a data field.


=head1 PUBLIC METHODS

These methods define the B<ScalarField> interface.

=head2 B<new()>

Class method that returns a new B<ScalarField>.

=head3 Positional Arguments

=over

=item 

B<$name> 

Used to refer to the field in a data record, e.g. C<%record{$name}>.

=item 

B<$pos | \@pos>

The position of the field in the input/output line. For delimited data this is 
the field index (starting at 0), and for fixed-width data this is the substring 
occupied by the field as given by its offset from 0 and total width (inclusive 
of any spacing between fields). Fixed-width fields are padded on the left or 
trimmed on the right to fit their allotted width on output.

=back

=head3 Named Options

=over

=item 

B<fmt=E<gt>$fmt>

A L<sprintf> format string that is used for formatted output (it has no effect
on input). Specifying a format width is optional, but for fixed-width fields a 
format width smaller than the field width can be used to specify whitespace 
between fields. 

=item 

B<quote=E<gt>$quote>

A quote character to strip on input and add to output. 

=item 

B<default=E<gt>$default>

A value to use for null fields. This is used on input if the field is blank and 
on output if the field is missing or defined as C<undef>.

=back

=head2 B<decode()>

Object method that converts a string token to a data field. This is used by
readers and normally does not need to be called in user code.

=head2 B<encode()>

Object method that converts a data field to a string token. This is used by
writers and normally does not need to be called in user code.


=head1 PUBLIC ATTRIBUTES

=head2 B<name>

The name assigned to this field. This is used by readers and writers and 
normally does not need to be used directly in user code.

=head2 B<pos>

The position of this field in each line of text. For a delimited field this is
a single index, and for a fixed-width field this is a substring specifier. This
is used by readers and writers and normally does not need to be used directly 
in user code.

=head2 B<width>

The width of this field. For a delimited field this is always 1, and for a 
fixed-width field this is the string length (inclusive of any whitespace). This
is used by readers and writers and normally does not need to be used directly 
in user code.


=head1 SEE ALSO

=over

=item L<Serial::Core::ConstField> 

=item L<Serial::Core::TimeField>

=item L<Serial::Core::DelimitedReader>

=item L<Serial::Core::DelimitedWriter>

=item L<Serial::Core::FixedWidthReader>

=item L<Serial::Core::FixedWidthWriter>

=back

=cut
