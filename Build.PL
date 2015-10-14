use 5.008;
use strict;
use warnings;
use Module::Build;


my $builder = Module::Build->new(
    module_name         => 'Serial::Core',
    license             => 'artistic_2',
    dist_author         => q{ Michael Klatt <mdklatt@ou.edu>},
    dist_version_from   => 'lib/Serial/Core.pm',
    release_status      => 'unstable',
    configure_requires => {
        'Module::Build' => 0,
    },
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        #'ABC'              => 1.6,
        #'Foo::Bar::Module' => 5.0401,
    },
    add_to_cleanup     => [ 'Serial-Core-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
