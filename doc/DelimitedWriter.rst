.. highlight:: perl


#############################
Serial::Core::DelimitedWriter
#############################

****
NAME
****


Serial::Core::DelimitedWriter - Write character-delimited tabular data.


********
SYNOPSIS
********



.. code-block:: perl

     use Serial::Core;
 
     my $writer = Serial::Core::DelimitedWriter->open($path, \@fields, $endl);
 
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


A \ **DelimitedWriter**\  writes character-delimited tabular data where each field
occupies the same position in every output line. One data record corresponds
to one line of output.


**************
PUBLIC METHODS
**************


These methods define the \ **DelimitedWriter**\  interface.

\ **new()**\ 
=============


Class method that returns a new \ **DelimitedWriter**\ .

Positional Arugments
--------------------



\ **$stream**\ 
 
 A stream handle opened for output.
 


\ **\\@fields**\ 
 
 An array of field objects. A field has a name, a position within each line of
 input, and encoding and decoding methods, \ *c.f.*\  `Serial::Core::ScalarField <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aScalarField&mode=module>`_.
 


\ **$delim**\ 
 
 Field delimiter to use.
 



Named Options
-------------



\ **endl=>$endl**\ 
 
 Endline character to use when writing output lines; defaults to \ ``$sol``\ .
 




\ **open()**\ 
==============


Class method that returns a new \ **DelimitedWriter**\  with automatic stream 
handling. Unlike a writer created with \ **new()**\ , the returned object will 
automatically close its input stream when it goes out of scope.

Positional Arguments
--------------------



\ **$stream**\ 
 
 This is either an open stream handle or a path to open as a normal text file.
 In either case, the resulting stream will be closed when the reader object goes
 out of scope.
 


\ **\\@fields**\ 
 
 An array of field objects. A field has a name, a position within each line of
 input, and encoding and decoding methods, \ *c.f.*\  `Serial::Core::ScalarField <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aScalarField&mode=module>`_.
 




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



