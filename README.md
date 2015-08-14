serial-perl
===========

Overview
--------
[![status][1]][2]

The [**serial-perl**][3] library provides tools for reading and writing
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
* Perl 5.8 - 5.20


Installation
------------

For local installation, place the [Serial][4] directory to the desired
location. For a system-wide installation, use the [`Makefile.PL`][5] script to
generate a Makefile (requires [ExtUtils::MakeMaker][6]).


    perl Makefile.PL
    make
    make test
    make install


Usage
-----

    use Serial::Core;
    
Individual modules are documented using [*POD*][7], which can be viewed using 
the [`perldoc`][8] command.

    perldoc Serial::Core


Testing
-------

Tests are contained in the [`t`][9] directory and can be run using the [`prove`][10] 
command.

    prove -Isrc



<!-- REFERENCES -->
[1]: https://travis-ci.org/mdklatt/serial-perl.png?branch=master "Travis build status"
[2]: https://travis-ci.org/mdklatt/serial-perl "Travis-CI"
[3]: http://github.com/mdklatt/serial-perl "GitHub/serial"
[4]: http://github.com/mdklatt/serial-perl/tree/master/lib/Serial "Serial tree"
[5]: http://github.com/mdklatt/serial-perl/blob/master/Makefile.PL "Makefile.PL"
[6]: http://search.cpan.org/~bingos/ExtUtils-MakeMaker-7.00/lib/ExtUtils/MakeMaker.pm "ExtUtils::MakeMaker on CPAN"
[7]: http://perldoc.perl.org/perlpod.html "Plain Old Documentation"
[8]: http://perldoc.perl.org/perldoc.html "perldoc command"
[9]: http://github.com/mdklatt/serial-perl/tree/master/t "tests directory"
[10]: http://perldoc.perl.org/prove.html "prove command"
