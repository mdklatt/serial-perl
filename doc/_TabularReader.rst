.. highlight:: perl


############################
Serial::Core::_TabularReader
############################

****
NAME
****


Serial::Core::_TabularReader - Abstract base class for tabular data readers.


********
SYNOPSIS
********



.. code-block:: perl

     use base qw(Serial::Core::_TabularReader);
     
     sub _init {
         my $self = shift @_;
         $self->SUPER::_init();
         # Define derived class attributes.
         return;
     }
     
     sub _split {
         my $self = shift @_;
         (my $line) = @_; 
         # Split an input line into an array of tokens.
         return \@tokens;
     }



***********
DESCRIPTION
***********


This is an abstract base class for implementing tabular data readers. Tabular
data is organized into fields such that each field occupies the same position
in each record. One line of text corresponds to one complete record.

Derived classes should override the \ **_init()**\  method as necessary, and must
implement a \ **_split()**\  method (see `PRIVATE METHODS`_).


**************
PUBLIC METHODS
**************


All public methods are inherited from `Serial::Core::_Reader <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3a_Reader&mode=module>`_.


***************
PRIVATE METHODS
***************


These methods are for implementing derived classes.

\ **_init()**\ 
===============


This is called by \ ``new()``\  to initialize the new object. Derived classes should 
override this to do any class-specific initialization.

Positional Arguments
--------------------



\ **$stream**\ 
 
 A stream handle opened for input.
 


\ **\\@fields**\ 
 
 An array of field objects. A field has a name, a position within each line of
 input, and encoding and decoding methods, \ *c.f.*\  `Serial::Core::ScalarField <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aScalarField&mode=module>`_.
 



Named Options
-------------



\ **endl=>$endl**\ 
 
 Endline character to use when reading input lines; defaults to \ ``$sol``\ .
 




\ **_split()**\ 
================


This must be implemented by derived classes to return an array of tokens for
a line of input.

Positional Arguments
--------------------



\ **$line**\ 
 
 A line of input text.
 




