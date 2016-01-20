use 5.008;
use strict;
use warnings;

use Module::Build;


my $builder = Module::Build->new(
    # See META.json and cpanfile for complete dependencies.
    # TODO: Can develop dependencies be specified here?
    module_name         => 'Serial::Core',
    license             => 'perl',
    dist_author         => q(Michael Klatt <mdklatt@alumni.ou.edu>),
    dist_version_from   => 'lib/Serial/Core.pm',
    release_status      => 'testing',
    add_to_cleanup      => ['_build/', 'blib/', 'MYMETA.*', 'Serial-Core-*'],
);

$builder->create_build_script();
