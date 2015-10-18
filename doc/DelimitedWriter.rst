.. highlight:: perl


#############################
Serial::Core::DelimitedWriter
#############################

****
NAME
****


Serial::Core::DelimitedWriter - write character-delimited tabular data


********
SYNOPSIS
********



.. code-block:: perl

     use Serial::Core;
 
     my $writer = Serial::Core::DelimitedWriter->new($stream, $fields);
     $writer->filter(sub {
         # Add a callback for output postprocessing.
         my ($record) = @_;
         ...
         return $record;  # or undef to drop this record
     };);
     foreach my $record (@records) {
         $writer->write($record);
     }



***********
DESCRIPTION
***********


A \ *DelimitedWriter*\  writes character-delimited tabular data where each field
occupies the same position in each output line. One data record corresponds to
one line of output.

CLASS METHODS
=============



new($stream, $fields, delim => "\t", endl => $/)
 
 Return a new \ *DelimitedWriter*\  object.
 


Required Positional Arguments
-----------------------------



\ *stream*\ 
 
 A handle to the output stream, which is any object for which 
 \ ``print $stream $line``\  writes an output line to the stream.
 


\ *fields*\ 
 
 An arrayref of one or more field definitions that define the output layout.
 



Optional Named Arguments
------------------------



\ *delim*\ 
 
 Specify the field delimter to use.
 


\ *endl*\ 
 
 Specify the endline character(s) to use.
 




OBJECT METHODS
==============



filter([$callback1, $callback2, ...])
 
 Add one or more filters to the writer, or without any arguments clear all
 filters. Filters are applied to each outgoing record in the order they were
 added; filtering stops as soon as any filter drops the record.
 


Optional Positional Arguments
-----------------------------



\ *callback ...*\ 
 
 Specify callbacks to use as filters. A filter takes a data record as its only
 argument and returns that record, a new/modified record, or \ ``undef``\  to drop
 the record.
 



write($record)
 
 Write a filtered and formatted data record to the output stream.
 



Required Positional Arguments
-----------------------------



\ *record*\ 
 
 The data record to write, where the record is a hashref keyed by field name.
 



dump($records)
 
 Write multiple records to the output stream, eqivalent to:
 
 
 .. code-block:: perl
 
      foreach my $record (@$records) {
          $writer->write($record);
      }
 
 



Required Positional Arguments
-----------------------------



\ *records*\ 
 
 An arrayref of records to be written.
 





*******
EXPORTS
*******


The \ *Serial::Core*\  library makes this class available by default.


********
SEE ALSO
********



ScalarField class



ConstField class



