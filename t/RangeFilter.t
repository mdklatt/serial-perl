# Test the Serial::Core::FieldFilter class module.
#
use strict;
use warnings;

use Test::More tests => 4;
use Serial::Core::RangeFilter;


our @values = (1, 2, 3);
our @records = map { {test => $_} } @values;


{
    # Test whitelist filtering.
    my $whitelist = Serial::Core::RangeFilter->new('test', [1, 2]);
    my @filtered = (@records[0, 1], undef);
    is_deeply([map { $whitelist->($_) } @records], \@filtered, 'whitelist');
}


{
    # Test blacklist filtering.
    my $blacklist = Serial::Core::RangeFilter->new('test', [1, 2], blacklist => 1);
    my @filtered = (undef, undef, $records[2]);
    is_deeply([map { $blacklist->($_) } @records], \@filtered, 'blacklist');
}


{
    # Test filtering with limits.
    my $filter = Serial::Core::RangeFilter->new('test', [undef, 2]);
    my @filtered = ($records[0], $records[1], undef);
    is_deeply([map { $filter->($_) } @records], \@filtered, 'limits: no min');
    $filter = Serial::Core::RangeFilter->new('test', [2, undef]);
    @filtered = (undef, $records[1], $records[2]);
    is_deeply([map { $filter->($_) } @records], \@filtered, 'limits: no max');
}
