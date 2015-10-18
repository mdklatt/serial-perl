.. highlight:: perl


########################
Serial::Core::ConstField
########################

****
NAME
****


Serial::Core::ConstField - define a constant value field


********
SYNOPSIS
********



.. code-block:: perl

     use Serial::Core;
 
     my @fields = (
         Serial::Core::ConstField->new($name, $pos, $value),
         ...
     );
     my $reader = new Serial::Core::DelimitedReader($stream, \@fields);
 
     my @fields = (
         Serial::Core::ConstField->new($name, [$beg, $len], $value),
         ...
     );
     my $reader = new Serial::Core::FixedWidthReader($stream, \@fields);



***********
DESCRIPTION
***********


A \ *ConstField*\  maps a constant input/output value to a data field. \ *Reader*\ s
and \ *Writer*\ s are initialized using a list of fields that defines the layout
of their data stream.

CLASS METHODS
=============



new($name, $pos, $value, fmt => '%s')
 
 Return a new \ *ConstField*\  object.
 


Required Positional Arguments
-----------------------------



\ *name*\ 
 
 Used to refer to the field in a data record, e.g. \ ``$record->{$name}``\ .
 


\ *pos*\ 
 
 The position of the field in the input/output line. For delimited data this is the field 
 index (starting at 0), and for fixed-width data this is the substring occupied 
 by the field as given by its offset from 0 and total width (inclusive of any 
 spacing between fields). Fixed-width fields are padded on the left or trimmed 
 on the right to fit their allotted width on output.
 


\ *value*\ 
 
 The constant value for this field.
 



Optional Named Arguments
------------------------



\ *fmt*\ 
 
 A \ ``printf()``\  format string that is used by a \ *Writer*\  for formatted output
 (it has no effect on input). Specifying a format width is optional, but for
 fixed-width fields a format width smaller than the field width can be used to
 control spacing between fields.
 




OBJECT METHODS
==============


The object methods are used by \ *Reader*\ s and \ *Writer*\ s; there is no need to
access a \ *ConstField*\  object directly.


OBJECT ATTRIBUTES
=================


The object attributes are used by \ *Reader*\ s and \ *Writer*\ s; there is no need 
to access a \ *ConstField*\  object directly.



*******
EXPORTS
*******


The \ *Serial::Core*\  library makes this class available by default.

