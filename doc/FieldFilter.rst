.. highlight:: perl


#########################
Serial::Core::FieldFilter
#########################

****
NAME
****


Serial::Core::FieldFilter - filter records using a set of values


********
SYNOPSIS
********



.. code-block:: perl

     use Serial::Core;
 
     my $filter = new Serial::Core::FieldFilter($field, $values);
     $reader->filter($filter);



***********
DESCRIPTION
***********


A \ *FieldFilter*\  is a callback that can be used with the \ ``filter()``\  method of 
a \ *Reader*\  or \ *Writer*\ . Field values are matched against a set of values, and
matching records can be whitelisted or blacklisted.

CLASS METHODS
=============



new($field, $values, blacklist => 0)
 
 Create a new \ *FieldFilter*\  object.
 


Required Positional Arguments
-----------------------------



\ *field*\ 
 
 The field name to match.
 


\ *value*\ 
 
 An arrayref specifying the values to match against.
 



Optional Named Arguments
------------------------



\ *blacklist*\ 
 
 Specify if matching records will be whitelisted or blacklisted. Set this to a
 true value to enable blacklisting.
 




OBJECT METHODS
==============


The object methods are used by \ *Reader*\ s and \ *Writer*\ s; there is no need to
access a \ *FieldFilter*\  object directly.



*******
EXPORTS
*******


The \ *Serial::Core*\  library makes this class available by default.

