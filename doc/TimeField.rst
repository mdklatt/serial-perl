.. highlight:: perl


#######################
Serial::Core::TimeField
#######################

****
NAME
****


Serial::Core::TimeField - Define a date/time field.


********
SYNOPSIS
********



.. code-block:: perl

     use Serial::Core;
 
     my @fields = (
         # Delimited fields have an index position.
         Serial::Core::TimeField->new($name, $pos, $fmt),
         ...
     );
     my $reader = new Serial::Core::DelimitedReader($stream, \@fields);
     my $writer = new Serial::Core::DelimitedWriter($stream, \@fields, ',');
 
     my @fields = (
         # Fixed-width fields have a substring position.
         Serial::Core::TimeField->new($name, [$beg, $len]),
         ...
     );
     my $reader = new Serial::Core::FixedWidthReader($stream, \@fields);
     my $writer = new Serial::Core::FixedWidthWriter($stream, \@fields);



***********
DESCRIPTION
***********


Readers and writers are initialized using a list of fields that defines the 
layout of their data stream. A \ **TimeField**\  maps a \ **Time::Piece**\  value to a 
data field.


**************
PUBLIC METHODS
**************


These methods define the \ **TimeField**\  interface.

\ **new()**\ 
=============


Class method that returns a new \ **TimeField**\ .

Positional Arguments
--------------------



\ **$name**\ 
 
 Used to refer to the field in a data record, e.g. \ ``%record{$name}``\ .
 


\ **$pos | \\@pos**\ 
 
 The position of the field in the input/output line. For delimited data this is 
 the field index (starting at 0), and for fixed-width data this is the substring 
 occupied by the field as given by its offset from 0 and total width (inclusive 
 of any spacing between fields). Fixed-width fields are padded on the left or 
 trimmed on the right to fit their allotted width on output.
 


\ **$fmt**\ 
 
 A strftime format string that is used to parse input and format output.
 



Named Options
-------------



\ **$default**\ 
 
 A value to use for null fields. This is used on input if the field is blank and 
 on output if the field is missing or defined as \ ``undef``\ .
 




\ **decode()**\ 
================


Object method that converts a string token to a data field. This is used by
readers and normally does not need to be called in user code.


\ **encode()**\ 
================


Object method that converts a data field to a string token. This is used by
writers and normally does not need to be called in user code.



*****************
PUBLIC ATTRIBUTES
*****************


\ **name**\ 
============


The name assigned to this field. This is used by readers and writers and 
normally does not need to be used directly in user code.


\ **pos**\ 
===========


The position of this field in each line of text. For a delimited field this is
a single index, and for a fixed-width field this is a substring specifier. This
is used by readers and writers and normally does not need to be used directly 
in user code.


\ **width**\ 
=============


The width of this field. For a delimited field this is always 1, and for a 
fixed-width field this is the string length (inclusive of any whitespace). This
is used by readers and writers and normally does not need to be used directly 
in user code.



********
SEE ALSO
********



`Serial::Core::ConstField <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aConstField&mode=module>`_



`Serial::Core::ScalarField <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aScalarField&mode=module>`_



`Serial::Core::DelimitedReader <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aDelimitedReader&mode=module>`_



`Serial::Core::DelimitedWriter <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aDelimitedWriter&mode=module>`_



`Serial::Core::FixedWidthReader <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aFixedWidthReader&mode=module>`_



`Serial::Core::FixedWidthWriter <http://search.cpan.org/search?query=Serial%3a%3aCore%3a%3aFixedWidthWriter&mode=module>`_



