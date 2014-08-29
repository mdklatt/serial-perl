# Test the Serial::Core::ScalarField class module.
#
use strict;
use warnings;

use Test::More;
use Serial::Core::ConstField;


# Define unit tests.

our $name = 'const';
our $width = 5;
our $pos = [1, $width];
our $value = 9999;
our $token = ' 9999';
our $field = Serial::Core::ConstField->new($name, $pos, $value);

sub test_new {
    is($field->{name}, $name, 'test_new: name attribute');
    is($field->{pos}, $pos, 'test_new: pos attribute');
    is($field->{width}, $width, 'test_new: width attribute');
    return;
}

sub test_decode {
    is($field->decode($token), $value, 'test_decode');
    is($field->decode(''), $value, 'test_decode: null');
    return;
}

sub test_encode {
    is($field->encode($value), $token, 'test_encode');
    is($field->encode(undef), $token, 'test_encode: null');
    my $field = Serial::Core::ConstField->new($name, $pos, $value, fmt => '%05d');
    is($field->encode(undef), '09999', 'test_encode: fmt');
    return;
}


# Run tests.

test_new();
test_decode();
test_encode();
done_testing();
