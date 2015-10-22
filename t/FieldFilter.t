# Test the Serial::Core::FieldFilter class module.
#
use strict;
use warnings;

use Test::More tests => 4;
use Serial::Core::FieldFilter;


our @values = ('abc', 'def', 'ghi');


{
    # Test whitelist filtering.
    my $whitelist = Serial::Core::FieldFilter->new('test', ['abc', 'def']);
    my @records = map { {test => $_} } @values;
    my @filtered = (@records[0, 1], undef);
    is_deeply([map { $whitelist->($_) } @records], \@filtered, 'whitelist');
    @records = ({not_test => 'abc'});
    @filtered = undef;
    is_deeply([map { $whitelist->($_) } @records], \@filtered, 'whitelist: empty');
}


{
    # Test blacklist filtering.
    my $blacklist = Serial::Core::FieldFilter->new('test', ['abc', 'def'],
        blacklist => 1);
    my @records = map { {test => $_} } @values;
    my @filtered = (undef, undef, $records[2]);
    is_deeply([map { $blacklist->($_) } @records], \@filtered, 'blacklist');
    @records = map { {not_test => $_} } @values;
    is_deeply([map { $blacklist->($_) } @records], \@records, 'blacklist');
}
