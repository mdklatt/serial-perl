use 5.008;
use strict;
use warnings;

use Module::Build;


my $_NAME = 'Serial-Core';

my $builder = Module::Build->new(
    # See META.json and cpanfile for complete dependencies.
    # TODO: Can develop dependencies be specified here?
    module_name => $_NAME,
    license => 'perl',
    dist_author => q(Michael Klatt <mdklatt@alumni.ou.edu>),
    dist_version_from => 'lib/Serial/Core.pm',
    release_status => 'testing',
    add_to_cleanup => ['_build/', 'blib/', 'MYMETA.*', "${_NAME}-*"],
);

$builder->create_build_script();


1;


__END__

=pod

=head1 NAME

Build.PL - The L<Module::Build> script for this application.


=head1 SYNOPSIS

    $ perl Build.PL
    $ ./Build
    $ ./Build test
    $ ./Build install


=head1 DESCRIPTION

This script generates a L<Module::Build> script named I<Build> that is used to
build, install, test, etc. this application. 

=head2 SPECIFYING REQUIREMENTS

In the traditional Perl tool chain, project requirements are listed in
I<META.yml> and I<META.json> (newer spec) files. B<Module::Build> will generate
these files automatically when C<Build metadist> is run; these files need to
be regenerated any time this file B<or> the version number is changed. The
I<META> files specify static requirements, and should be included as part of
the distribution (this is in contrast to I<MYMETA> files, which are generated
during build and reflect any system-specific settings on the destination
machine).

A limitation of the traditional tool chain is that project dependencies are
expected to be on CPAN or its equivalent. However, some installation tools 
support alternate requirement locations such as Git repos. In particular, 
B<cpanm> can read requirement specifications from a I<cpanfile> in addition to 
the standard I<META> files. The requirements listed in a I<cpanfile> can be
Git addresses in addition to CPAN module names. Also, the I<cpanfile> format
supports the I<develop> phase for requirements, but B<Module::Build> does not.

However, the I<cpanfile> cannot completely replace the I<META> files for 
dependency management, at least when using B<cpanm>. There are at least two 
cases where requirements B<MUST> be in a I<META> file. First, any I<configure>
phase requirements must be in a I<META> file, or B<cpanm> file will not install
them before trying to run this script. Second, if this project is used as a 
dependency by another project, B<cpanm> will ignore the I<cpanfile> when trying
to recursively satisfy dependencies.

Based on this, the recommended guidance is to put dependencies in I<META> files
whenever possible by listing them in this script, and only use a I<cpanfile>
for Git repo dependencies and I<develop> phase dependencies. To avoid redundant
information, dependencies listed here should not be listed in the I<cpanfile>.

If this project has any required dependencies in the I<cpanfile>, e.g. projects
in Git repos, installing this project as the dependency of an upstream project
will not "just work". In this case, the upstream project must also list these 
I<cpanfile> requirements in its own I<cpanfile>.
