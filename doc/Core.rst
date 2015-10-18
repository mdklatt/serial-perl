.. highlight:: perl


############
Serial::Core
############

****
NAME
****


Serial::Core - read and write sequential record-oriented data


********
SYNOPSIS
********



.. code-block:: perl

     use Serial::Core;



***********
DESCRIPTION
***********


The Serial::Core library provides tools for reading and writing sequential
record-oriented data. The library defines \ *Reader*\  classes for parsing data 
from an input stream and \ *Writer*\  classes for writing data to an output 
stream. Both \ *Reader*\ s and \ *Writer*\ s support filtering via callbacks.


*******
EXPORTS
*******


These classes are available by default. Other library classes must be imported
explicitly.


\ *DelimitedReader*\ 
 
 Reads character-delimited tabular data.
 


\ *DelimitedWriter*\ 
 
 Writes character-delimited tabular data.
 


\ *FixedWidthReader*\ 
 
 Reads fixed-width tabular data.
 


\ *FixedWidthWriter*\ 
 
 Writes fixed-width tabular data.
 


\ *ScalarField*\ 
 
 Define a scalar input/ouput field.
 


\ *ScalarField*\ 
 
 Define a constant value input/ouput field.
 


\ *FieldFilter*\ 
 
 Filter input/output using a set of field values.
 


\ *RangeFilter*\ 
 
 Filter input/output using a numerical range of field values.
 


