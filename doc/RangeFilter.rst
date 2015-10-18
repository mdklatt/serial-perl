.. highlight:: perl


#########################
Serial::Core::RangeFilter
#########################

****
NAME
****


Serial::Core::RangeFilter - filter records using a numerical range


********
SYNOPSIS
********



.. code-block:: perl

     use Serial::Core;
 
     my $filter = new Serial::Core::RangeFilter($field, [$min, $max]);
     $reader->filter($filter);



***********
DESCRIPTION
***********


A \ *RangeFilter*\  is a callback that can be used with the \ ``filter()``\  method of 
a \ *Reader*\  or \ *Writer*\ . Field values are matched against a numeric range,
and matching records can be whitelisted or blacklisted.

CLASS METHODS
=============



new($field, $range, blacklist => 0)
 
 Create a new \ *RangeFilter*\  object.
 


Required Positional Arguments
-----------------------------



\ *field*\ 
 
 The field name to match.
 


\ *range*\ 
 
 An arrayref specifying the numerical range [min, max] to match against; if 
 either value is \ ``undef``\  the range is unlimited at that end.
 



Optional Named Arguments
------------------------



\ *blacklist*\ 
 
 Specify if matching records will be whitelisted or blacklisted. Set this to a
 true value to enable blacklisting.
 




OBJECT METHODS
==============


The object methods are used by \ *Reader*\ s and \ *Writer*\ s; there is no need to
access a \ *RangeFilter*\  object directly.



*******
EXPORTS
*******


The \ *Serial::Core*\  library makes this class available by default.

