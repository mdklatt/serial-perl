package Serial::Core::ConstField;

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
    return $self->{_value};
}


sub encode {
    my $self = shift @_;
    return $self->{_token};
}


sub _init {
    # This is called by new() to do the real work when an object is created.
    # Derived classes may override this as necessary.
    my $self = shift @_;
    ($self->{name}, $self->{pos}, $self->{_value}, my %opts) = @_;
    my $valfmt = $opts{fmt} || '%s';
    my $token = sprintf $valfmt, $self->{_value};
    if (ref($self->{pos}) eq 'ARRAY') {
        # This is a fixed-width field; the width is in characters. The value is
        # padded on the left or trimmed on the right to fit the allotted width.
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

Serial::Core::ConstField - Define a constant value field.


=head1 SYNOPSIS

    use Serial::Core;

    my @fields = (
        # Delimited fields have an index position.
        Serial::Core::ConstField->new($name, $pos, $value),
        ...
    );
    my $reader = new Serial::Core::DelimitedReader($stream, \@fields);
    my $writer = new Serial::Core::DelimitedWriter($stream, \@fields, ',');

    my @fields = (
        # Fixed-width fields have a substring position.
        Serial::Core::ConstField->new($name, [$beg, $len], $value),
        ...
    );
    my $reader = new Serial::Core::FixedWidthReader($stream, \@fields);
    my $writer = new Serial::Core::FixedWidthWriter($stream, \@fields);


=head1 DESCRIPTION

Readers and writers are initialized using a list of fields that defines the 
layout of their data stream. A B<ConstField> maps a constant scalar value to a 
data field. 


=head1 PUBLIC METHODS

These methods define the B<ConstField> interface.

=head2 B<new()>

Class method that returns a new B<ConstField>.

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

=item 

B<$value>

The constant value for this field. The field is always assigned this value on 
input and written as this value on output. 

=back

=head3 Named Options

=over

=item 

B<fmt=E<gt>$fmt>

A L<sprintf> format string that is used for formatted output (it has no effect
on input). Specifying a format width is optional, but for fixed-width fields a 
format width smaller than the field width can be used to specify whitespace 
between fields. 

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

=item L<Serial::Core::ScalarField> 

=item L<Serial::Core::TimeField>

=item L<Serial::Core::DelimitedReader>

=item L<Serial::Core::DelimitedWriter>

=item L<Serial::Core::FixedWidthReader>

=item L<Serial::Core::FixedWidthWriter>

=back

=cut
