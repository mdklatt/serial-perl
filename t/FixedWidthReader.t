# Test the Serial::Core::FixedWidthReader class module.
#
use strict;
use warnings;

use Test::More;
use Fcntl qw(SEEK_SET);
use Serial::Core::ScalarField;
use Serial::Core::FixedWidthReader;


# Define unit tests.

our $fields = [
    Serial::Core::ScalarField->new('str', [0, 2]), 
    Serial::Core::ScalarField->new('int', [2, 2])
];

sub test_next {
    open my $stream, '<', \" a 1\n b 2\n";
    my $reader = Serial::Core::FixedWidthReader->new($stream, $fields);
    is_deeply({$reader->next()}, {str => 'a', int => 1}, 'test_next');
    open $stream, '<', \" a 1X b 2X";
    $reader = Serial::Core::FixedWidthReader->new($stream, $fields, endl => 'X');
    is_deeply({$reader->next()}, {str => 'a', int => 1}, 'test_next: endl');
    return;
}

sub test_read {
    my @records = (
        {str => 'a', int => 1}, 
        {str => 'b', int => 2}, 
        {str => 'c', int => 3},
    );
    open my $stream, '<', \" a 1\n b 2\n c 3\n";
    my $reader = Serial::Core::FixedWidthReader->new($stream, $fields);
    is_deeply([$reader->read()], \@records, "test_read");
    seek $stream, 0, SEEK_SET;
    $reader = Serial::Core::FixedWidthReader->new($stream, $fields);
    is_deeply([$reader->read(count => 2)], [@records[0..1]], "test_read: count");
    return;
}


# Run tests.

test_next();
test_read();
done_testing();
