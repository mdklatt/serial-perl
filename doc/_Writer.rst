.. highlight:: perl


#####################
Serial::Core::_Writer
#####################

****
NAME
****


Serial::Core::_Writer - Abstract base class for serial data writers.


********
SYNOPSIS
********



.. code-block:: perl

     use base qw(Serial::Core::_Writer);
     
     sub _init {
         my $self = shift @_;
         $self->SUPER::_init();
         # Define derived class attributes.
         return;
     }
     
     sub _put {
         my $self = shift @_;
         my ($record) = @_;
         # Write a formatted record to the output stream.
         return;
     }



***********
DESCRIPTION
***********


This is an abstract base class for implementing serial data writers. A writer
converts records consisting of named data fields to sequential output, \ *e.g.*\ 
lines of text. Output can be passed through one or more filters to modify 
and/or reject each record.

Derived classes should override the \ **_init()**\  method as necessary, and must
implement a \ **_put()**\  method (see `PRIVATE METHODS`_).


**************
PUBLIC METHODS
**************


All derived classes will have the following interface.

\ **new()**\ 
=============


Class method that returns a new reader of the appropriate type.


\ **filter()**\ 
================


Add one or more filters to the writer, or call without any arguments to clear
all filters.

Positional Arguments
--------------------



[\ **\\&filter1, ...**\ ]
 
 A filter is any \ ``sub``\  that accepts a record as its only argument and returns 
 a record (as a hashref) or \ ``undef``\  to drop the record from the input sequence.
 Records are passed through each filter in the order they were added. A record 
 is dropped as soon as any filter returns \ ``undef``\ . Thus, it is more efficient 
 to order filters from most to least exclusive.
 




\ **write()**\ 
===============


Write a filtered record to the output stream.

Positional Arguments
--------------------



\ **\\%record**\ 
 
 The record to write. The record will be passed through all filters before being 
 written.
 




\ **dump()**\ 
==============


Write a sequence of records to the output stream.

Positional Arguments
--------------------



\ **\\@records**\ 
 
 An array of records to write. Each record will be passed through all filters 
 before being written.
 





***************
PRIVATE METHODS
***************


These methods are for implementing derived classes.

\ **_init()**\ 
===============


This is called by \ **new()**\  to initialize the new object. Derived classes should 
override this to do any class-specific initialization.

Arguments
---------


This method is called using any arguments passed to \ **new()**\ .



\ **_put()**\ 
==============


This must be implemented by derived classes to format a record and write it to
the output stream.

Positional Arguments
--------------------



\ **\\%record**\ 
 
 The record to write.
 




