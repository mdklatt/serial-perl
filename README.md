Serial::Core
============

Overview
--------
[![status][1]][2]

The [**Serial::Core**][3] library provides tools for reading and writing
record-oriented data in various formats. The core library is contained in the
`Serial::Core` package. Library extensions will be contained in their own 
`Serial` package.


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

    $ perl Build.PL
    $ ./Build
    $ ./Build test
    $ ./Bulld install


Usage
-----

    use Serial::Core;
    

Sphinx Documenation
-------------------

This project supports the [Sphinx][4] documentation system in addition to the
normal Perl documentation. A basic Sphinx setup is contained in the `doc/` 
directory. The [reStructuredText][5] files used by Spinx can be generated 
automatically from the project POD documenation with the custom `librst` build 
command:

    $ ./Bulld librst
    

<!-- REFERENCES -->
[1]: https://travis-ci.org/mdklatt/serial-perl.png?branch=master "Travis build status"
[2]: https://travis-ci.org/mdklatt/serial-perl "Travis-CI"
[3]: http://github.com/mdklatt/serial-perl "GitHub/serial-perl"
[4]: http://sphinx-doc.org "Sphinx"
[5]: http://docutils.sourceforge.net/rst.html "reStructuredText overview"
