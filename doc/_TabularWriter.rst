.. highlight:: perl


############################
Serial::Core::_TabularWriter
############################

****
NAME
****


Serial::Core::_TabularWriter - Abstract base class for tabular data writers.


********
SYNOPSIS
********



.. code-block:: perl

     use base qw(Serial::Core::_TabularWriter);
     
     sub _init {
         my $self = shift @_;
         $self->SUPER::_init();
         # Define derived class attributes.
         return;
     }
     
     sub _join {
         my $self = shift @_;
         my ($tokens) = @_;
         # Join tokens into a line of output.
         return $line;
     }



***********
DESCRIPTION
***********


This is an abstract base class for implementing tabular data writers. Tabular
data is organized into fields such that each field occupies the same position
in each record. One line of text corresponds to one complete record.

Derived classes should override the \ **_init()**\  method as necessary, and must
implement a \ **_join()**\  method (see `PRIVATE METHODS`_).


**************
PUBLIC METHODS
**************


All public methods are inherited from `Serial::Core::_Writer <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3a_Writer&mode=module>`_.


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
 
 A stream handle opened for output.
 


\ **\\@fields**\ 
 
 An array of field objects. A field has a name, a position within each line of
 input, and encoding and decoding methods, \ *c.f.*\  `Serial::Core::ScalarField <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aScalarField&mode=module>`_.
 



Named Options
-------------



\ **endl=>$endl**\ 
 
 Endline character to use when writing output lines; defaults to \ ``$sol``\ .
 




\ **_join()**\ 
===============


This must be implemented by derived classes to join an array of tokens into a
single line of text.

Positional Arguments
--------------------



\ **\\@tokens**\ 
 
 An array of formatted text tokens.
 




