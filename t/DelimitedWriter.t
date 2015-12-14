use strict;
use warnings;

use Fcntl qw(SEEK_SET);

use Test::More tests => 7;
use Serial::Core::ScalarField;
use Serial::Core::DelimitedWriter;


our $fields = [
    Serial::Core::ScalarField->new('str', 0), 
    Serial::Core::ScalarField->new('int', 1)
];
our @records = (
    {str => 'a', int => 0}, 
    {str => 'b', int => 1}, 
    {str => 'c', int => 2},
);


do {
    # Test the open() method.
    # TODO: Need to test with a file path.
    my $buffer;
    open my $stream, '>', \$buffer;
    do {
        # The $writer should automatically close its stream when it goes out of
        # scope upon exit from this block.
        my $writer = Serial::Core::DelimitedWriter->open($stream, $fields);
        $writer->write($records[0]);
        is($buffer, "a\t0\n", 'open: writable');
    };
    no warnings qw(closed);  # silence tell() warning about closed file handle
    is(tell($stream), -1, 'open: closed');
};


do {
    # Test the write() method.
    my $buffer;
    open my $stream, '>', \$buffer;
    my $writer = Serial::Core::DelimitedWriter->new($stream, $fields);
    $writer->write($records[0]);
    is($buffer, "a\t0\n", 'write');
    seek $stream, 0, SEEK_SET;
    $writer = Serial::Core::DelimitedWriter->new($stream, $fields, delim => ',');
    $writer->write($records[0]);
    is($buffer, "a,0\n", 'write: delim');
    seek $stream, 0, SEEK_SET;
    $writer = Serial::Core::DelimitedWriter->new($stream, $fields, endl => 'X');
    $writer->write($records[0]);
    is($buffer, "a\t0X", 'write: endl');
};


do {
    # Thest the dump() method.
    my $buffer;
    open my $stream, '>', \$buffer;
    my $writer = Serial::Core::DelimitedWriter->new($stream, $fields);
    $writer->dump(\@records);
    is($buffer, "a\t0\nb\t1\nc\t2\n", 'dump');
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
    my $writer = Serial::Core::DelimitedWriter->new($stream, $fields);
    $writer->filter($reject, $modify);
    $writer->dump(\@records);
    is($buffer, "b\t2\nc\t4\n", 'filter');
};
