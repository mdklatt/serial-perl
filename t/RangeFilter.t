# Test the Serial::Core::FieldFilter class module.
#
use strict;
use warnings;
use Test::More;

use Serial::Core::RangeFilter;

# Define unit tests.

our @values = (1, 2, 3);

sub test_whitelist {
    my $whitelist = Serial::Core::RangeFilter->new('test', [1, 2]);
    my @records = map { {test => $_} } @values;
    my @filtered = (@records[0, 1], undef);
    is_deeply([map { $whitelist->call($_) } @records], \@filtered, 'test_whitelist');
    return;
}

sub test_blacklist {
    my $blacklist = Serial::Core::RangeFilter->new('test', [1, 2], blacklist => 1);
    my @records = map { {test => $_} } @values;
    my @filtered = (undef, undef, $records[2]);
    is_deeply([map { $blacklist->call($_) } @records], \@filtered, 'test_blacklist');
    return;
}


# Run tests.

test_whitelist();
test_blacklist();
done_testing();