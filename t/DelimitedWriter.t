# Test the Serial::Core::DelimitedWriter class module.
#
use strict;
use warnings;

use Test::More;
use Fcntl qw(SEEK_SET);
use Serial::Core::ScalarField;
use Serial::Core::DelimitedWriter;


# Define unit tests.

our $fields = [
    Serial::Core::ScalarField->new('str', 0), 
    Serial::Core::ScalarField->new('int', 1)
];

our @records = (
    {str => 'a', int => 1}, 
    {str => 'b', int => 2}, 
    {str => 'c', int => 3},
);

sub test_write {
    my $buffer;
    open my $stream, '>', \$buffer;
    my $writer = Serial::Core::DelimitedWriter->new($stream, $fields);
    $writer->write($records[0]);
    is($buffer, "a\t1\n", 'test_writer');
    seek $stream, 0, SEEK_SET;
    $writer = Serial::Core::DelimitedWriter->new($stream, $fields, delim => ',');
    $writer->write($records[0]);
    is($buffer, "a,1\n", 'test_writer: delim');
    seek $stream, 0, SEEK_SET;
    $writer = Serial::Core::DelimitedWriter->new($stream, $fields, endl => 'X');
    $writer->write($records[0]);
    is($buffer, "a\t1X", 'test_writer: endl');
    return;
}

sub test_dump {
    my $buffer;
    open my $stream, '>', \$buffer;
    my $writer = Serial::Core::DelimitedWriter->new($stream, $fields);
    $writer->dump(\@records);
    is($buffer, "a\t1\nb\t2\nc\t3\n", 'test_dump');
    return;
}

sub test_filter {
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
    is($buffer, "b\t4\nc\t6\n", 'test_filter');
    return;
}
    

# Run tests.

test_write();
test_dump();
test_filter();
done_testing();