use 5.008000;
use strict;
use warnings;
use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME => 'Serial::Core',
    VERSION_FROM => 'src/Serial/Core.pm', # finds $VERSION
    PREREQ_PM => {}, # e.g., Module::Name => 1.1
    ABSTRACT_FROM => 'src/Serial/Core.pm', # retrieve abstract from module
    MIN_PERL_VERSION => 5.008,
    AUTHOR => 'Michael Klatt <mdklatt@ou.edu>',
);
