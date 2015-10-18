.. highlight:: perl


#######################
Serial::Core::TimeField
#######################

****
NAME
****


Serial::Core::TimeField - define a time field


********
SYNOPSIS
********



.. code-block:: perl

     use Serial::Core;
 
     my @fields = (
         Serial::Core::TimeField->new('date', [0, 10], '%Y-%m-%d'),
         ...
     );



***********
DESCRIPTION
***********


A \ *TimeField*\  maps a single input/output token to a Time::Piece field. 
\ *Reader*\ s and \ *Writer*\ s are initialized using a list of fields that defines
the layout of their data stream.

CLASS METHODS
=============



new($name, $pos, $fmt, default => undef)
 
 Return a new \ *TimeField*\  object.
 


Positional Arguments (Required)
-------------------------------



\ *name*\ 
 
 Used to refer to the field in a data record, e.g. \ ``$record->{$name}``\ .
 


\ *pos*\ 
 
 The position of the field in the input/output line. For delimited data this is 
 the field index (starting at 0), and for fixed-width data this is the substring
 occupied by the field as given by its offset from 0 and total width (inclusive 
 of any spacing between fields). Fixed-width fields are padded on the left or 
 trimmed on the right to fit their allotted width on output.
 


\ *fmt*\ 
 
 A strftime-compatible format string.
 



Named Arguments (Optional)
--------------------------



\ *default*\ 
 
 Specify a default value to use for null fields. This is used on input if the 
 field is blank and on output if the field is not defined in the data record.
 




OBJECT METHODS
==============


The object methods are used by \ *Reader*\ s and \ *Writer*\ s; there is no need to
access an \ *TimeField*\  object directly.


\ ``decode``\ 
 
 Convert a string token to a Time::Piece value. If the string is empty, the
 field's default value is used.
 


\ ``encode``\ 
 
 Convert a Time::Piece value to a string token. If the value is null, the 
 field's default value is encoded. For fixed-width fields, the string is padded
 on the left or trimmed on he right to fit within the field.
 



OBJECT ATTRIBUTES
=================


The object attributes are used by \ *Reader*\ s and \ *Writer*\ s; there is no need 
to access a \ *TimeField*\  object directly.


\ ``name``\ 
 
 The field name.
 


\ ``pos``\ 
 
 The position of the field within the record, either an index or a 
 (begin, length) tuple for a fixed-width field.
 




*******
EXPORTS
*******


The \ *Serial::Core*\  library makes this class available by default.

