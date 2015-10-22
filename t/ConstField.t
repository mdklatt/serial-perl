# Test the Serial::Core::ScalarField class module.
#
use strict;
use warnings;

use Test::More tests => 8;
use Serial::Core::ConstField;


our $name = 'const';
our $width = 5;
our $pos = [1, $width];
our $value = 9999;
our $token = ' 9999';
our $field = Serial::Core::ConstField->new($name, $pos, $value);


{
    # Test the new() method.
    is($field->{name}, $name, 'new: name');
    is($field->{pos}, $pos, 'new: pos');
    is($field->{width}, $width, 'new: width');
}


{
    # Test the decode() method.
    is($field->decode($token), $value, 'decode');
    is($field->decode(''), $value, 'decode: null');
}


{
    # Test the encode() method.
    is($field->encode($value), $token, 'encode');
    is($field->encode(undef), $token, 'encode: null');
    my $field = Serial::Core::ConstField->new($name, $pos, $value, fmt => '%05d');
    is($field->encode(undef), '09999', 'encode: fmt');
}
