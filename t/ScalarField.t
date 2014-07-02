# Test the Serial::Core::ScalarField class.
#
use strict;
use warnings;

use Test::More(tests => 11);

use Serial::Core::ScalarField;


# Define unit tests.

sub test_new {
    my $name = 'name';
    my $pos = 1;
    my $width = 1;
    my $field = Serial::Core::ScalarField->new($name, $pos, $width);
    ok($field->{name} eq $name, 'test_new: name attribute');
    ok($field->{pos} == $pos, 'test_new: pos attribute');
    ok($field->{width} == $width, 'test_new: width attribute');
    return;
}

sub test_new_fixed {
    my $name = 'name';
    my $pos = [1, 2];
    my $width = 2;
    my $field = Serial::Core::ScalarField->new($name, $pos, $width);
    ok($field->{name} eq $name, 'test_new_fixed: name attribute');
    ok($field->{pos} == $pos, 'test_new_fixed: pos attribute');
    ok($field->{width} == $width, 'test_new_fixed: width attribute');
    return;
}

sub test_decode {
    my $field = Serial::Core::ScalarField->new('name', 0);
    ok($field->decode(" abc ") eq 'abc', 'test_decode');
    return;
}

sub test_decode_null {
    my $field = Serial::Core::ScalarField->new('name', 0);
    is($field->decode(' '), undef, 'test_decode_null');
    return;
}

sub test_encode {
    my $field = Serial::Core::ScalarField->new('name', 0);
    ok($field->encode('abc') eq 'abc', 'test_encode');
    return;
}

sub test_encode_fixed {
    my $field = Serial::Core::ScalarField->new('name', [0, 4]);
    ok($field->encode('abc') eq ' abc', 'test_encode_fixed: padded');
    ok($field->encode('abcde') eq 'abcd', 'test_encode_fixed: trimmed');
    return;
}


# Run tests.

test_new();
test_new_fixed();
test_decode();
test_decode_null();
test_encode();
test_encode_fixed();
