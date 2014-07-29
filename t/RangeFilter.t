# Test the Serial::Core::FieldFilter class module.
#
use strict;
use warnings;
use Test::More;

use Serial::Core::RangeFilter;

# Define unit tests.

our @values = (1, 2, 3);
our @records = map { {test => $_} } @values;

sub test_whitelist {
    my $whitelist = Serial::Core::RangeFilter->new('test', [1, 2]);
    my @filtered = (@records[0, 1], undef);
    is_deeply([map { $whitelist->($_) } @records], \@filtered, 'test_whitelist');
    return;
}

sub test_blacklist {
    my $blacklist = Serial::Core::RangeFilter->new('test', [1, 2], blacklist => 1);
    my @filtered = (undef, undef, $records[2]);
    is_deeply([map { $blacklist->($_) } @records], \@filtered, 'test_blacklist');
    return;
}

sub test_limits {
    my $filter = Serial::Core::RangeFilter->new('test', [undef, 2]);
    my @filtered = ($records[0], $records[1], undef);
    is_deeply([map { $filter->($_) } @records], \@filtered, 'test_limits: no min');
    $filter = Serial::Core::RangeFilter->new('test', [2, undef]);
    @filtered = (undef, $records[1], $records[2]);
    is_deeply([map { $filter->($_) } @records], \@filtered, 'test_limits: no max');
    return;
}


# Run tests.

test_whitelist();
test_blacklist();
test_limits();
done_testing();