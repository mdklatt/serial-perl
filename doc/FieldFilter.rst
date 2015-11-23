.. highlight:: perl


#########################
Serial::Core::FieldFilter
#########################

****
NAME
****


Serial::Core::FieldFilter - Filter a data field against a set of values.


********
SYNOPSIS
********



.. code-block:: perl

     use Serial::Core;
     
     my @values = ('foo', 'bar');
     my $reader = Serial::Core::FixedWidthReader->new($stream, \@fields);
     $reader->filter(Serial::Core::FieldFilter->new('field', \@values));



***********
DESCRIPTION
***********


A \ **FieldFilter**\  filters a record by matching a data field against a set of
values. The filter can act as either a whitelist (default) or blacklist to 
accept or reject any matching records, respectively. The record is not 
modified. A filter can be attached to readers and writers using their 
\ ``filter()``\  method.


**************
PUBLIC METHODS
**************


These methods define the \ **FieldFilter**\  interface.

\ **new()**\ 
=============


Class method that returns a new \ **FieldFilter**\ .

Positional Arugments
--------------------



\ **$field**\ 
 
 The data field name to use with this filter.
 


\ **\\@values**\ 
 
 An array of values to match against.
 



Named Options
-------------



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



`Serial::Core::RangeFilter <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aRangeFilter&mode=module>`_



`Serial::Core::DelimitedReader <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aDelimitedReader&mode=module>`_



`Serial::Core::DelimitedWriter <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aDelimitedWriter&mode=module>`_



`Serial::Core::FixedWidthReader <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aFixedWidthReader&mode=module>`_



`Serial::Core::FixedWidthWriter <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aFixedWidthWriter&mode=module>`_



