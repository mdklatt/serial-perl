.. highlight:: perl


###########################
Serial::Core::_RecordFilter
###########################

****
NAME
****


Serial::Core::_RecordFilter - Abstract base class for record filters.


********
SYNOPSIS
********



.. code-block:: perl

     use base qw(Serial::Core::_RecordFilter);
     
     sub _init {
         my $self = shift @_;
         $self->SUPER::_init();
         # Define derived class attributes.
         return;
     }
     
     sub _match {
         my $self = shift @_;
         my ($value) = @_;
         # Test the value against the filter condition.
         return $match;
     }



***********
DESCRIPTION
***********


This is an abstract base class for implementing record filters. A record filter
matches a single field in a data record against a condition. The filter can act
as either a whitelist (default) or blacklist to accept or reject any matching 
records, respectively. The record is not modified. A filter can be attached to 
readers and writers using their \ ``filter()``\  method.


**************
PUBLIC METHODS
**************


All derived classes will have the following interface.

\ **new()**\ 
=============


Class method that returns a new filter of the appropriate type.


\ **&{} operator**\ 
====================


The class overloads \ **&{}**\  so that it can be used as a subroutine reference.
This is used by readers and writers and normally does not need to be called in
user code.

Positional Arguments
--------------------



\ **\\%record**\ 
 
 A data record to match.
 





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



\ **_match()**\ 
================


This must be implemented by derived classes to return true if a value matches
the filter condition.

Positional Arguments
--------------------



\ **$value**\ 
 
 The value to test against the filter condition.
 




