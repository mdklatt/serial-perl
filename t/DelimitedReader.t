# Test the Serial::Core::DelimitedReader class module.
#
use strict;
use warnings;

use Test::More;
use Fcntl qw(SEEK_SET);
use Serial::Core::ScalarField;
use Serial::Core::DelimitedReader;


# Define unit tests.

our $fields = [
    Serial::Core::ScalarField->new('str', 0), 
    Serial::Core::ScalarField->new('int', 1)
];

sub test_next {
    open my $stream, '<', \" a  1 \n b  2 \n";
    my $reader = Serial::Core::DelimitedReader->new($stream, $fields);
    is_deeply({$reader->next()}, {str => 'a', int => 1}, 'test_next: whitespace');
    open $stream, '<', \" a,  1\n b,  2\n";
    $reader = Serial::Core::DelimitedReader->new($stream, $fields, delim => ',');
    is_deeply({$reader->next()}, {str => 'a', int => 1}, 'test_next: delim');
    open $stream, '<', \" a  1  X b  2  X";
    $reader = Serial::Core::DelimitedReader->new($stream, $fields, endl=> 'X');
    is_deeply({$reader->next()}, {str => 'a', int => 1}, 'test_next: endl');
    return;
}

sub test_read {
    open my $stream, '<', \" a  1 \n b  2 \n c  3 \n";
    my @records = (
        {str => 'a', int => 1}, 
        {str => 'b', int => 2}, 
        {str => 'c', int => 3},
    );
    my $reader = Serial::Core::DelimitedReader->new($stream, $fields);
    is_deeply([$reader->read()], \@records, "test_read");
    seek $stream, 0, SEEK_SET;
    $reader = Serial::Core::DelimitedReader->new($stream, $fields);
    is_deeply([$reader->read(count => 2)], [@records[0..1]], "test_read: count");
    return;
}


# Run tests.

test_next();
test_read();
done_testing();