## Test suite for the Serial::Core::TimeField module.
##
use strict;
use warnings;

use Test::More tests => 15;
use Serial::Core::TimeField;


my $timestr = "2015-10-15";
my $timefmt = "%Y-%m-%d";
my $timeval = Time::Piece->strptime($timestr, $timefmt);


{
    # Test the new() method.
    my $name = 'scalar';
    my $pos = 1;
    my $width = 1;
    my $field = Serial::Core::TimeField->new($name, $pos);
    is($field->{name}, $name, 'new: name');
    is($field->{pos}, $pos, 'new: pos');
    is($field->{width}, $width, 'new: width');
}



{
    # Test the new() method for fixed-width fields.
    my $name = 'scalar';
    my $pos = [1, 2];
    my $width = 2;
    my $field = Serial::Core::TimeField->new($name, $pos);
    is($field->{name}, $name, 'new: fixed: name');
    is($field->{pos}, $pos, 'new: fixed: pos');
    is($field->{width}, $width, 'new: fixed: width ');
}



{
    # Test the decode() method.
    my $field = Serial::Core::TimeField->new('time', 0, $timefmt);
    is($field->decode(" ${timestr} "), $timeval, 'decode: value');
    is($field->decode(' '), undef, 'decode: null');
    my %opts = ('default' => -999);
    $field = Serial::Core::TimeField->new('time', 0, $timefmt, %opts);
    is($field->decode(' '), $opts{'default'}, 'decode: default');
}


{
    # Test the encode() method.
    my $field = Serial::Core::TimeField->new('time', 0, $timefmt);
    is($field->encode($timeval), $timestr, 'encode: value');
    is($field->encode(undef), '', 'encode: null');
    my %opts = ('default' => -999);
    $field = Serial::Core::TimeField->new('time', 0, $timefmt, %opts);
    is($field->encode(undef), $opts{'default'}, 'encode: default');
}



{
    # Test the encode() method for a fixed-width field.
    my $field = Serial::Core::TimeField->new('time', [0, 11], $timefmt);
    is($field->encode($timeval), ' 2015-10-15', 'encode: fixed: padded');
    $field = Serial::Core::TimeField->new('time', [0, 4], $timefmt);
    is($field->encode($timeval), '2015', 'encode: fixed: trimmed');
    is($field->encode(undef), '    ', 'encode: fixed: null');
}
