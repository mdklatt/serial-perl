.. highlight:: perl


#########################
Serial::Core::RangeFilter
#########################

****
NAME
****


Serial::Core::RangeFilter - Filter a data field against a numeric range.


********
SYNOPSIS
********



.. code-block:: perl

     use Serial::Core;
     
     my $reader = Serial::Core::FixedWidthReader->new($stream, \@fields);
     $reader->filter(Serial::Core::RangeFilter->new('field', min=>0, max=>5));



***********
DESCRIPTION
***********


A \ **RangeFilter**\  filters a record by matching a data field against the numeric
range [min, max]. The filter can act as either a whitelist (default) or 
blacklist to accept or reject any matching records, respectively. The record is 
not modified. A filter can be attached to readers and writers using their 
\ ``filter()``\  method.


**************
PUBLIC METHODS
**************


These methods define the \ **RangeFilter**\  interface.

\ **new()**\ 
=============


Class method that returns a new \ **RangeFilter**\ .

Positional Arugments
--------------------



\ **$field**\ 
 
 The data field name to use with this filter.
 



Named Options
-------------



\ **min=>$min**\ 
 
 Minimum (inclusive) of the range to match; defaults to \ ``undef``\ , in which case
 the range is unbounded in this direction.
 


\ **max=>$max**\ 
 
 Maximum (inclusive) of the range to match; defaults to \ ``undef``\ , in which case
 the range is unbounded in this direction.
 


\ **blacklist=>$blacklist**\ 
 
 Boolean value to control blacklisting; defaults to false.
 




\ **&{} operator**\ 
====================


The class overloads \ **&{}**\  so that it can be used as a subroutine reference.
This is used by readers and writers and normally does not need to be called in
user code.



********
SEE ALSO
********



`Serial::Core::FieldFilter <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aFieldFilter&mode=module>`_



`Serial::Core::DelimitedReader <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aDelimitedReader&mode=module>`_



`Serial::Core::DelimitedWriter <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aDelimitedWriter&mode=module>`_



`Serial::Core::FixedWidthReader <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aFixedWidthReader&mode=module>`_



`Serial::Core::FixedWidthWriter <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aFixedWidthWriter&mode=module>`_



