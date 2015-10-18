.. highlight:: perl


#############################
Serial::Core::DelimitedReader
#############################

****
NAME
****


Serial::Core::DelimitedReader - read character-delimited tabular data


********
SYNOPSIS
********



.. code-block:: perl

     use Serial::Core;
 
     my $reader = Serial::Core::DelimitedReader->new($stream, $fields);
     $reader->filter(sub {
         # Add a callback for input preprocessing.
         my ($record) = @_;
         ...
         return $record;  # or undef to drop this record
     };);
     while (my $record = $reader->next()) {
         # Process each record.
         ...
     }



***********
DESCRIPTION
***********


A \ *DelimitedReader*\  reads character-delimited tabular data where each field
occupies the same position in each input line. One line of input corresponds 
to one data record.

CLASS METHODS
=============



new($stream, $fields, delim => undef, endl => $\)
 
 Return a new \ *DelimitedReader*\  object.
 


Required Positional Arguments
-----------------------------



\ *stream*\ 
 
 A handle to the input stream, which is any object for which 
 \ ``<$stream>``\  returns a line of input.
 


\ *fields*\ 
 
 An arrayref of one or more field definitions that define the input layout.
 



Optional Named Arguments
------------------------



\ *delim*\ 
 
 Specify the field delimiter to use; by default, input lines are split on any 
 whitespace.
 


\ *endl*\ 
 
 Specify the endline character(s) to use.
 




OBJECT METHODS
==============



filter([$callback1, $callback2, ...])
 
 Add one or more filters to the reader, or without any arguments clear all
 filters. Filters are applied to each incoming record in the order they were
 added; filtering stops as soon as any filter drops the record.
 


Optional Positional Arguments
-----------------------------



\ *callback ...*\ 
 
 Specify callbacks to use as filters. A filter takes a data record as its only
 argument and returns that record, a new/modified record, or \ ``undef``\  to drop
 the record.
 



next()
 
 Return the next parsed and filtered record from the input stream. Each record 
 is a hash keyed by the field names. On EOF \ ``undef``\  is returned, so this can be 
 used in a \ ``while``\  loop.
 


read()
 
 Return all records from the stream as an array or arrayref.
 





*******
EXPORTS
*******


The \ *Serial::Core*\  library makes this class available by default.


********
SEE ALSO
********



ScalarField class



ConstField class



