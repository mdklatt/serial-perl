.. highlight:: perl


##############################
Serial::Core::FixedWidthWriter
##############################

****
NAME
****


Serial::Core::FixedWidthWriter - Write fixed-width tabular data.


********
SYNOPSIS
********



.. code-block:: perl

     use Serial::Core;
     
     my $writer = Serial::Core::FixedWidthWriter->new($stream, \@fields);
     
     $writer->filter(sub {
         my ($record) = @_;
         # Modify record as necessary.
         return $record;  # or return undef to reject this record
     });
     
     $writer->write($record);  # write a record
 
     $writer->dump(\@records);  # write all records



***********
DESCRIPTION
***********


A \ **FixedWidthWriter**\  writes fixed-width tabular data where each field occupies
the same column in every output line. One line of input corresponds to one data 
record.


**************
PUBLIC METHODS
**************


These methods define the \ **FixedWidthWriter**\  interface.

\ **new()**\ 
=============


Class method that returns a new \ **FixedWidthWriter**\ .

Positional Arugments
--------------------



\ **$stream**\ 
 
 A stream handle opened for output.
 


\ **\\@fields**\ 
 
 An array of field objects. A field has a name, a position within each line of
 input, and encoding and decoding methods, \ *c.f.*\  `Serial::Core::ScalarField <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aScalarField&mode=module>`_.
 



Named Options
-------------



\ **endl => $endl**\ 
 
 Endline character to use when writing output lines; defaults to \ ``$sol``\ .
 




\ **filter()**\ 
================


Add one or more filters to the writer, or call without any arguments to clear
all filters.

Positional Arguments
--------------------



[\ **\\&filter1, ...**\ ]
 
 A filter is any \ ``sub``\  that accepts a record as its only argument and returns 
 a record (as a hashref) or \ ``undef``\  to stop the record from being written.
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
 





********
SEE ALSO
********



`Serial::Core::ConstField <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aConstField&mode=module>`_



`Serial::Core::ScalarField <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aScalarField&mode=module>`_



`Serial::Core::TimeField <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aTimeField&mode=module>`_



`Serial::Core::FieldFilter <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aFieldFilter&mode=module>`_



`Serial::Core::RangeFilter <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aRangeFilter&mode=module>`_



