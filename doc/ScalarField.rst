.. highlight:: perl


#########################
Serial::Core::ScalarField
#########################

****
NAME
****


Serial::Core::ScalarField - define a scalar data field


********
SYNOPSIS
********



.. code-block:: perl

     use Serial::Core;
 
     my @fields = (
         Serial::Core::ScalarField->new($name, $pos),
         ...
     );
     my $reader = new Serial::Core::DelimitedReader($stream, \@fields);
 
     my @fields = (
         Serial::Core::ScalarField->new($name, [$beg, $len]),
         ...
     );
     my $reader = new Serial::Core::FixedWidthReader($stream, \@fields);



***********
DESCRIPTION
***********


A \ *ScalarField*\  maps a single input/output token to a data field. \ *Reader*\ s
and \ *Writer*\ s are initialized using a list of fields that defines the layout
of their data stream.

CLASS METHODS
=============



new($name, $pos, fmt => '%s', quote => '', default => undef)
 
 Return a new \ *ScalarField*\  object.
 


Required Positional Arguments
-----------------------------



\ *name*\ 
 
 Used to refer to the field in a data record, e.g. \ ``$record->{$name}``\ .
 


\ *pos*\ 
 
 The position of the field in the input/output line. For delimited data this is 
 the field index (starting at 0), and for fixed-width data this is the substring 
 occupied by the field as given by its offset from 0 and total width (inclusive 
 of any spacing between fields). Fixed-width fields are padded on the left or 
 trimmed on the right to fit their allotted width on output.
 



Optional Named Arguments
------------------------



\ *fmt*\ 
 
 A \ ``printf()``\  format string that is used by a \ *Writer*\  for formatted output
 (it has no effect on input). Specifying a format width is optional, but for
 fixed-width fields a format width smaller than the field width can be used to
 control spacing between fields.
 


\ *quote*\ 
 
 Specify a \ *quote*\  character to strip input of leading/trailing quotes and to 
 automatically quote output.
 


\ *default*\ 
 
 Specify a default value to use for null fields. This is used on input if the 
 field is blank and on output if the field is not defined in the data record.
 




OBJECT METHODS
==============


The object methods are used by \ *Reader*\ s and \ *Writer*\ s; there is no need to
access a \ *ScalarField*\  object directly.


OBJECT ATTRIBUTES
=================


The object attributes are used by \ *Reader*\ s and \ *Writer*\ s; there is no need 
to access a \ *ScalarField*\  object directly.



*******
EXPORTS
*******


The \ *Serial::Core*\  library makes this class available by default.

