use strict;
use warnings;

use Fcntl qw(SEEK_SET);

use Test::More tests => 6;
use Serial::Core::ScalarField;
use Serial::Core::FixedWidthWriter;


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
    my $buffer;
    open my $stream, '>', \$buffer;
    do {
        # The $writer should automatically close its stream when it goes out of
        # scope upon exit from this block.
        my $writer = Serial::Core::FixedWidthWriter->open($stream, $fields);
        $writer->write($records[0]);
        is($buffer, " a 1\n", 'open: writable');
    };
    no warnings qw(closed);  # silence tell() warning about closed file handle
    is(tell($stream), -1, 'open: closed');
};


do {
    # Test the write() method.
    my $buffer;
    open my $stream, '>', \$buffer;
    my $writer = Serial::Core::FixedWidthWriter->new($stream, $fields);
    $writer->write($records[0]);
    is($buffer, " a 1\n", 'write');
    seek $stream, 0, SEEK_SET;
    $writer = Serial::Core::FixedWidthWriter->new($stream, $fields, endl => 'X');
    $writer->write($records[0]);
    is($buffer, " a 1X", 'write: endl');
};


do {
    # Test the dump() method.
    my $buffer;
    open my $stream, '>', \$buffer;
    my $writer = Serial::Core::FixedWidthWriter->new($stream, $fields);
    $writer->dump(\@records);
    is($buffer, " a 1\n b 2\n c 3\n", 'dump');
};


do {
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
    my $buffer;
    open my $stream, '>', \$buffer;
    my $writer = Serial::Core::FixedWidthWriter->new($stream, $fields);
    $writer->filter($reject, $modify);
    $writer->dump(\@records);
    is($buffer, " b 4\n c 6\n", 'filter');
};
