# Test the Serial::Core::FieldFilter class module.
#
use strict;
use warnings;
use Test::More;

use Serial::Core::FieldFilter;


# Define unit tests.

our @values = ('abc', 'def', 'ghi');


sub test_whitelist {
    my $whitelist = Serial::Core::FieldFilter->new('test', ['abc', 'def']);
    my @records = map { {test => $_} } @values;
    my @filtered = (@records[0, 1], undef);
    is_deeply([map { $whitelist->call($_) } @records], \@filtered, 'test_whitelist');
    @records = ({not_test => 'abc'});
    @filtered = (undef);
    is_deeply([map { $whitelist->call($_) } @records], \@filtered, 'test_whitelist');
    return;
}

sub test_blacklist {
    my $blacklist = Serial::Core::FieldFilter->new('test', ['abc', 'def'],
        blacklist => 1);
    my @records = map { {test => $_} } @values;
    my @filtered = (undef, undef, $records[2]);
    is_deeply([map { $blacklist->call($_) } @records], \@filtered, 'test_blacklist');
    @records = map { {not_test => $_} } @values;
    is_deeply([map { $blacklist->call($_) } @records], \@records, 'test_blacklist');
    return;
}


# Run tests.

test_whitelist();
test_blacklist();
done_testing();