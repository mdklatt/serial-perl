# Test the Serial::Core::DelimitedReader class module.
#
use strict;
use warnings;

use Fcntl qw(SEEK_SET);

use Test::More tests => 6;
use Serial::Core::ScalarField;
use Serial::Core::DelimitedReader;


our $fields = [
    Serial::Core::ScalarField->new('str', 0), 
    Serial::Core::ScalarField->new('int', 1)
];
our @records = (
    {str => 'a', int => 0}, 
    {str => 'b', int => 1}, 
    {str => 'c', int => 2},
);


{
    # Test the next() method.
    open my $stream, '<', \" a  0 \n b  1 \n c  2";
    my $reader = Serial::Core::DelimitedReader->new($stream, $fields);
    is_deeply({$reader->next()}, $records[0], 'next: whitespace');
    open $stream, '<', \" a,  0\n b,  1\n c,  2";
    $reader = Serial::Core::DelimitedReader->new($stream, $fields, delim => ',');
    is_deeply({$reader->next()}, $records[0], 'next: delim');
    open $stream, '<', \" a  0  X b  1  X c  2";
    $reader = Serial::Core::DelimitedReader->new($stream, $fields, endl=> 'X');
    is_deeply({$reader->next()}, $records[0], 'next: endl');
}


{
    # Test the read() method.
    open my $stream, '<', \" a  0 \n b  1 \n c  2 \n";
    my $reader = Serial::Core::DelimitedReader->new($stream, $fields);
    is_deeply([$reader->read()], \@records, 'read');
    seek $stream, 0, SEEK_SET;
    $reader = Serial::Core::DelimitedReader->new($stream, $fields);
    is_deeply([$reader->read(count => 2)], [@records[0..1]], 'read: count');
}


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
    my @filtered = ({str => 'b', int => 2}, {str => 'c', int => 4});
    open my $stream, '<', \" a  0 \n b  1 \n c  2 \n";
    my $reader = Serial::Core::DelimitedReader->new($stream, $fields);
    $reader->filter($reject, $modify);
    is_deeply([$reader->read()], \@filtered, "filter");
}
