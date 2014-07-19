# Test the Serial::Core::DelimitedReader class module.
#
use strict;
use warnings;
use Test::More;

use Serial::Core::ScalarField;
use Serial::Core::DelimitedReader;


# Define unit tests.

our $fields = [
    Serial::Core::ScalarField->new('str', 0), 
    Serial::Core::ScalarField->new('int', 1)
];

sub test_read {
    open my $stream, '<', \" a  1 \n b  2 \n";
    my $reader = Serial::Core::DelimitedReader->new($stream, $fields);
    is_deeply({$reader->read()}, {str => 'a', int => 1}, 'test_read: whitespace');
    open $stream, '<', \" a,  1\n b,  2\n";
    $reader = Serial::Core::DelimitedReader->new($stream, $fields, delim => ',');
    is_deeply({$reader->read()}, {str => 'a', int => 1}, 'test_read: delim');
    open $stream, '<', \" a  1  X b  2  X";
    $reader = Serial::Core::DelimitedReader->new($stream, $fields, endl=> 'X');
    is_deeply({$reader->read()}, {str => 'a', int => 1}, 'test_read: endl');
    return;
}

sub test_all {
    open my $stream, '<', \" a  1 \n b  2 \n";
    my $reader = Serial::Core::DelimitedReader->new($stream, $fields);
    my @records = ({str => 'a', int => 1}, {str => 'b', int => 2});
    is_deeply([$reader->all()], \@records, "test_all");
    return;
}


# Run tests.

test_read();
test_all();
done_testing();