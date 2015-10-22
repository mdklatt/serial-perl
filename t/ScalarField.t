## Test suite for the Serial::Core::ScalarField class module.
##
use strict;
use warnings;

use Test::More tests => 18;
use Serial::Core::ScalarField;


{
    # Test the new() method.
    my $name = 'name';
    my $pos = 1;
    my $width = 1;
    my $field = Serial::Core::ScalarField->new($name, $pos);
    is($field->{name}, $name, 'new: name');
    is($field->{pos}, $pos, 'new: pos');
    is($field->{width}, $width, 'tnew: width');
}


{   
    # Test the new() method for fixed-width fields.
    my $name = 'name';
    my $pos = [1, 2];
    my $width = 2;
    my $field = Serial::Core::ScalarField->new($name, $pos);
    is($field->{name}, $name, 'new: fixed: name');
    is($field->{pos}, $pos, 'new: fixed: pos');
    is($field->{width}, $width, 'new: fixed: width');
}


{
    # Test the decode() method.
    my $field = Serial::Core::ScalarField->new('name', 0);
    is($field->decode('  a b c  '), 'a b c', 'decode: value');
    is($field->decode(' '), undef, 'decode: null');
    my $default = -999;
    $field = Serial::Core::ScalarField->new('name', 0, default => $default);
    is($field->decode(' '), $default, 'decode: default');
    $field = Serial::Core::ScalarField->new('name', 0, quote => '"');
    is($field->decode('""a"b"c"'), 'a"b"c', 'decode: quoted');
}


{
    # Test the encode() method.
    my $field = Serial::Core::ScalarField->new('name', 0);
    is($field->encode('abc'), 'abc', 'encode');
    is($field->encode(undef), '', 'encode: null');
    $field = Serial::Core::ScalarField->new('name', 0, fmt => '%5.3f');
    is($field->encode(1.23), '1.230', 'encode: formatted');
    my $default = -999;
    $field = Serial::Core::ScalarField->new('name', 0, default => $default);
    is($field->encode(undef), -999, 'encode: default');
    $field = Serial::Core::ScalarField->new('name', 0, quote => '"');
    is($field->encode('abc'), '"abc"', 'encode: quoted');
}


{
    # Test the encode() method for fixed-width fields.
    my $field = Serial::Core::ScalarField->new('name', [0, 4]);
    is($field->encode('abc'), ' abc', 'encode: fixed: padded');
    is($field->encode('abcde'), 'abcd', 'encode: fixed: trimmed');
    is($field->encode(undef), '    ', 'encode: fixed: null');
}
