.. highlight:: perl


#############################
Serial::Core::DelimitedReader
#############################

****
NAME
****


Serial::Core::DelimitedReader - Read character-delimited tabular data.


********
SYNOPSIS
********



.. code-block:: perl

     use Serial::Core;
     
     my $reader = Serial::Core::DelimitedReader->new($stream, \@fields);
     
     $reader->filter(sub {
         my ($record) = @_;
         # Modify record as necessary.
         return $record;  # or return undef to drop record from the input sequence
     });
     
     while (my $record = $reader->next()) {
         # Process each record.
     }
     
     my @records = $reader->read(count=>10);  # read at most 10 records



***********
DESCRIPTION
***********


A \ **DelimitedReader**\  reads character-delimited tabular data where each field
occupies the same position in every input line. One line of input corresponds 
to one data record.


**************
PUBLIC METHODS
**************


These methods define the \ **DelimitedReader**\  interface.

\ **new()**\ 
=============


Class method that returns a new \ **DelimitedReader**\ .

Positional Arugments
--------------------



\ **$stream**\ 
 
 A stream handle opened for input.
 


\ **\\@fields**\ 
 
 An array of field objects. A field has a name, a position within each line of
 input, and encoding and decoding methods, \ *c.f.*\  `Serial::Core::ScalarField <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aScalarField&mode=module>`_.
 



Named Options
-------------



\ **delim=>$delim**\ 
 
 Field delimiter to use; the default is to split lines on any whitespace.
 


\ **endl=>$endl**\ 
 
 Endline character to use when reading input lines; defaults to \ ``$sol``\ .
 




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
 





********
SEE ALSO
********



`Serial::Core::ConstField <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aConstField&mode=module>`_



`Serial::Core::ScalarField <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aScalarField&mode=module>`_



`Serial::Core::TimeField <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aTimeField&mode=module>`_



`Serial::Core::FieldFilter <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aFieldFilter&mode=module>`_



`Serial::Core::RangeFilter <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aRangeFilter&mode=module>`_



