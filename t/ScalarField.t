## Test suite for the Serial::Core::ScalarField class module.
##
use strict;
use warnings;

use Test::More tests => 18;
use Serial::Core::ScalarField;


{
    my $name = 'name';
    my $pos = 1;
    my $width = 1;
    my $field = Serial::Core::ScalarField->new($name, $pos);
    is($field->{name}, $name, 'test_new: name attribute');
    is($field->{pos}, $pos, 'test_new: pos attribute');
    is($field->{width}, $width, 'test_new: width attribute');
}


{   
    my $name = 'name';
    my $pos = [1, 2];
    my $width = 2;
    my $field = Serial::Core::ScalarField->new($name, $pos);
    is($field->{name}, $name, 'test_new_fixed: name attribute');
    is($field->{pos}, $pos, 'test_new_fixed: pos attribute');
    is($field->{width}, $width, 'test_new_fixed: width attribute');
}


{
    my $field = Serial::Core::ScalarField->new('name', 0);
    is($field->decode('  a b c  '), 'a b c', 'test_decode: value');
    is($field->decode(' '), undef, 'test_decode: null');
    my $default = -999;
    $field = Serial::Core::ScalarField->new('name', 0, default => $default);
    is($field->decode(' '), $default, 'test_decode: default');
    $field = Serial::Core::ScalarField->new('name', 0, quote => '"');
    is($field->decode('""a"b"c"'), 'a"b"c', 'test_decode: quoted');
}


{
    my $field = Serial::Core::ScalarField->new('name', 0);
    is($field->encode('abc'), 'abc', 'test_encode: value');
    is($field->encode(undef), '', 'test_encode: null');
    $field = Serial::Core::ScalarField->new('name', 0, fmt => '%5.3f');
    is($field->encode(1.23), '1.230', 'test_encode: formatted');
    my $default = -999;
    $field = Serial::Core::ScalarField->new('name', 0, default => $default);
    is($field->encode(undef), -999, 'test_encode: default');
    $field = Serial::Core::ScalarField->new('name', 0, quote => '"');
    is($field->encode('abc'), '"abc"', 'test_encode: quoted');
}


{
    my $field = Serial::Core::ScalarField->new('name', [0, 4]);
    is($field->encode('abc'), ' abc', 'test_encode_fixed: padded');
    is($field->encode('abcde'), 'abcd', 'test_encode_fixed: trimmed');
    is($field->encode(undef), '    ', 'test_encode_fixed: null');
}
