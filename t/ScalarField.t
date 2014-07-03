# Test the Serial::Core::ScalarField class.
#
use strict;
use warnings;
use Test::More(tests => 14);

use Serial::Core::ScalarField;


# Define unit tests.

sub test_new {
    my $name = 'name';
    my $pos = 1;
    my $width = 1;
    my $field = Serial::Core::ScalarField->new($name, $pos);
    is($field->{name}, $name, 'test_new: name attribute');
    is($field->{pos}, $pos, 'test_new: pos attribute');
    is($field->{width}, $width, 'test_new: width attribute');
    return;
}

sub test_new_fixed {
    my $name = 'name';
    my $pos = [1, 2];
    my $width = 2;
    my $field = Serial::Core::ScalarField->new($name, $pos);
    is($field->{name}, $name, 'test_new_fixed: name attribute');
    is($field->{pos}, $pos, 'test_new_fixed: pos attribute');
    is($field->{width}, $width, 'test_new_fixed: width attribute');
    return;
}

sub test_decode {
    my $field = Serial::Core::ScalarField->new('name', 0);
    is($field->decode(' abc '), 'abc', 'test_decode: value');
    is($field->decode(' '), undef, 'test_decode: null');
    return;
}

sub test_encode {
    my $field = Serial::Core::ScalarField->new('name', 0);
    is($field->encode('abc'), 'abc', 'test_encode: value');
    is($field->encode(undef), '', 'test_encode: null');
    $field = Serial::Core::ScalarField->new('name', 0, fmt => '%5.3f');
    is($field->encode(1.23), '1.230', 'test_encode: formatted');
    return;
}

sub test_encode_fixed {
    my $field = Serial::Core::ScalarField->new('name', [0, 4]);
    is($field->encode('abc'), ' abc', 'test_encode_fixed: padded');
    is($field->encode('abcde'), 'abcd', 'test_encode_fixed: trimmed');
    is($field->encode(undef), '    ', 'test_encode_fixed: null');
    return;
}


# Run tests.

test_new();
test_new_fixed();
test_decode();
test_encode();
test_encode_fixed();
