.. highlight:: perl


#####################
Serial::Core::_Reader
#####################

****
NAME
****


Serial::Core::_Reader - Abstract base class for serial data readers.


********
SYNOPSIS
********



.. code-block:: perl

     use base qw(Serial::Core::_Reader);
     
     sub _init {
         my $self = shift @_;
         $self->SUPER::_init();
         # Define derived class attributes.
         return;
     }
     
     sub _get {
         my $self = shift @_;
         # Get the next record from the stream.
         return \%record;
     }



***********
DESCRIPTION
***********


This is an abstract base class for implementing serial data readers. A reader 
converts sequential input, \ *e.g.*\  lines of text, to records consisting of 
named data fields. Input can be passed through one or more filters to modify 
and/or reject each record.

Derived classes should override the \ **_init()**\  method as necessary, and must
implement a \ **_get()**\  method (see `PRIVATE METHODS`_).


**************
PUBLIC METHODS
**************


All derived classes will have the following interface.

\ **new()**\ 
=============


Class method that returns a new reader of the appropriate type.


\ **filter()**\ 
================


Add one or more filters to the reader, or call without any arguments to clear
all filters.

Positional Arguments
--------------------



[\ **\\&filter1, ...**\ ]
 
 A filter is any \ ``sub``\  that accepts a record as its only argument and returns 
 a record (as a hashref) or \ ``undef``\  to drop the record from the input sequence.
 Records are passed through each filter in the order they were added. A record 
 is dropped as soon as any filter returns \ ``undef``\ . Thus, it is more efficient 
 to order filters from most to least exclusive.
 




\ **next()**\ 
==============


Return the next filtered input record or \ ``undef``\  on EOF.


\ **read()**\ 
==============


Return all filtered input records as an array.

Named Options
-------------



\ **count=>$count**\ 
 
 Return \ **$count**\  records at most.
 





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



\ **_get()**\ 
==============


This must be implemented by derived classes to return the next parsed input
record or \ ``undef``\  on EOF.


