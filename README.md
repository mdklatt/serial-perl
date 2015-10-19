serial-perl
===========

Overview
--------
[![status][1]][2]

The [**Serial-Core**][3] library provides tools for reading and writing
record-oriented data in various formats. The core library is contained in the
`Serial::Core` package. Library extensions will be contained in their own 
packages.


Current Features
----------------
* Read/write delimited and fixed-width data
* Named and typed data fields


Planned Features
----------------
* Aggregation
* Sorting
* Advanced data transformations 


Requirements
------------
* Perl 5.8 - 5.22


Installation
------------

For local installation, place the [Serial][4] directory to the desired
location. For a system-wide installation, use [`Build.PL`][5] to 
generate a [`Module::Build`][6] build script.


    $ perl Build.PL
    $ ./Build
    $ ./Build test
    $ ./Bulld install


Usage
-----

    use Serial::Core;
    
Individual modules are documented using [*POD*][7], which can be viewed using 
the [`perldoc`][8] command.

    $ perldoc Serial::Core


Sphinx Documenation
-------------------

This project supports the [Sphinx][9] documentation system in addition to the
normal Perl documentation. A basic Sphinx setup is contained in the `doc/` 
directory. The [reStructuredText][10] files used by Spinx can be generated 
automatically from the project POD documenation with the custom `librst` build 
command:

    $ ./Bulld librst
    
This requires the [`Pod::POM`][11] and [`Pod::POM::View::Restructured`][12]
modules, and a version of [`Module::Build`][6] that supports subclassing.



<!-- REFERENCES -->
[1]: https://travis-ci.org/mdklatt/serial-perl.png?branch=master "Travis build status"
[2]: https://travis-ci.org/mdklatt/serial-perl "Travis-CI"
[3]: http://github.com/mdklatt/serial-perl "GitHub/serial"
[4]: http://github.com/mdklatt/serial-perl/tree/master/lib/Serial "Serial tree"
[5]: http://github.com/mdklatt/serial-perl/blob/master/Build.PL "Build.PL"
[6]: http://search.cpan.org/~leont/Module-Build-0.4214/lib/Module/Build.pm "Module::Build on CPAN"
[7]: http://perldoc.perl.org/perlpod.html "Plain Old Documentation"
[8]: http://perldoc.perl.org/perldoc.html "perldoc command"
[9]: http://sphinx-doc.org "Sphinx"
[10]: http://docutils.sourceforge.net/rst.html "reStructuredText overview"
[11]: http://search.cpan.org/~abw/Pod-POM-0.17/lib/Pod/POM.pm "Pod::POM on CPAN"
[12]: http://search.cpan.org/~neilb/Pod-POM-2.00/lib/Pod/POM/View/HTML.pm "Pod::POM::View::Restructured on CPAN"

