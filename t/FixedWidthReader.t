# Test the Serial::Core::FixedWidthReader class module.
#
use strict;
use warnings;

use Fcntl qw(SEEK_SET);

use Test::More tests => 7;
use Serial::Core::ScalarField;
use Serial::Core::FixedWidthReader;


our $fields = [
    Serial::Core::ScalarField->new('str', [0, 2]), 
    Serial::Core::ScalarField->new('int', [2, 2])
];
our @records = (
    {str => 'a', int => 1}, 
    {str => 'b', int => 2}, 
    {str => 'c', int => 3},    
);


do {
    # Test the open() method.
    # TODO: Need to test with a file path.
    open my $stream, '<', \" a 1\n b 2\n";
    do {
        # The $reader should automatically close its stream when it goes out of
        # scope upon exit from this block.
        my $reader = Serial::Core::FixedWidthReader->open($stream, $fields);
        is_deeply({$reader->next()}, $records[0], 'open: readable');
    };
    no warnings qw(closed);  # silence tell() warning about closed file handle
    is(tell($stream), -1, 'open: closed');
};


do {
    # Test the next() method.
    open my $stream, '<', \" a 1\n b 2\n";
    my $reader = Serial::Core::FixedWidthReader->new($stream, $fields);
    is_deeply({$reader->next()}, $records[0], 'next');
    open $stream, '<', \" a 1X b 2X";
    $reader = Serial::Core::FixedWidthReader->new($stream, $fields, endl => 'X');
    is_deeply({$reader->next()}, $records[0], 'next: endl');
};


do {
    # Test the read() method.
    open my $stream, '<', \" a 1\n b 2\n c 3\n";
    my $reader = Serial::Core::FixedWidthReader->new($stream, $fields);
    is_deeply([$reader->read()], \@records, "read");
    seek $stream, 0, SEEK_SET;
    $reader = Serial::Core::FixedWidthReader->new($stream, $fields);
    is_deeply([$reader->read(count => 2)], [@records[0..1]], "read: count");
};


{
    # Test the filter() method.
    my $reject = sub { 
        my ($record) = @_;
        return $record->{str} ne 'a' ? $record : undef; 
    };
    my $modify = sub { 
        my ($record) = @_;
        $record->{int} *= 2; 
        return $record;
    };
    my @filtered = ({str => 'b', int => 4}, {str => 'c', int => 6});
    open my $stream, '<', \" a 1\n b 2\n c 3\n";
    my $reader = Serial::Core::FixedWidthReader->new($stream, $fields);
    $reader->filter($reject, $modify);
    is_deeply([$reader->read()], \@filtered, "filter");
}
