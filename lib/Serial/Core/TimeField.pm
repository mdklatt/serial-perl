package Serial::Core::TimeField;
use base qw(Serial::Core::ScalarField);

use strict;
use warnings;

use Time::Piece;


sub decode {
    my $self = shift @_;
    my ($token) = @_;
    $token =~ s/^\s+|\s+$//g;
    if (not $token) {
        return $self->{_default};
    }
    return Time::Piece->strptime($token, $self->{_valfmt});
}


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

Serial::Core::TimeField - Define a date/time field.


=head1 SYNOPSIS

    use Serial::Core;

    my @fields = (
        # Delimited fields have an index position.
        Serial::Core::TimeField->new($name, $pos, $fmt),
        ...
    );
    my $reader = new Serial::Core::DelimitedReader($stream, \@fields);
    my $writer = new Serial::Core::DelimitedWriter($stream, \@fields, ',');

    my @fields = (
        # Fixed-width fields have a substring position.
        Serial::Core::TimeField->new($name, [$beg, $len]),
        ...
    );
    my $reader = new Serial::Core::FixedWidthReader($stream, \@fields);
    my $writer = new Serial::Core::FixedWidthWriter($stream, \@fields);


=head1 DESCRIPTION

Readers and writers are initialized using a list of fields that defines the 
layout of their data stream. A B<TimeField> maps a B<Time::Piece> value to a 
data field.


=head1 PUBLIC METHODS

These methods define the B<TimeField> interface.

=head2 B<new()>

Class method that returns a new B<TimeField>.

=head3 Positional Arguments

=over

=item B<$name> 

Used to refer to the field in a data record, e.g. C<%record{$name}>.

=item B<$pos | \\@pos>

The position of the field in the input/output line. For delimited data this is 
the field index (starting at 0), and for fixed-width data this is the substring 
occupied by the field as given by its offset from 0 and total width (inclusive 
of any spacing between fields). Fixed-width fields are padded on the left or 
trimmed on the right to fit their allotted width on output.

=item B<$fmt>

A L<strftime> format string that is used to parse input and format output.

=back

=head3 Named Options

=over

=item B<$default>

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

=item L<Serial::Core::ScalarField> 

=item L<Serial::Core::DelimitedReader>

=item L<Serial::Core::DelimitedWriter>

=item L<Serial::Core::FixedWidthReader>

=item L<Serial::Core::FixedWidthWriter>

=back

=cut
