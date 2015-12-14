########
Tutorial
########

Overview
========

The **Serial::Core** library can be used to read and write serial data
consisting of sequential records of typed fields. Data is read into or written
from associative arrays that are keyed by field name. The core library is 
contained in the ``Serial::Core`` namespace, and extensions will be contained 
in their own ``Serial`` namespace.


Reading Data
============

This is fixed-width data consisting of a station identifier, a date string, a
time string, and observations from a sensor array. Each observation has a
floating point value and an optional flag string.

::

    340010 2012-02-01 00:00 UTC -999.00M -999.00S
    340010 2012-03-01 00:00 UTC   72.00     1.23A
    340010 2012-04-01 00:10 UTC   63.80Q    0.00

This data stream can be read using a ``FixedWidthReader``. The reader must be
initialized with an array of field definitions. Each field is associated with
a data type and defined by its name and position. For a fixed-width field the
position array is a substring specifier (beg, len), inclusive of any spaces 
between fields.

..  code-block:: perl

    use strict;
    use warnings;
    
    use Serial::Core;  # imports all Serial::Core classes
    
    my @fields = (
        # Ignoring time zone field. 
        Serial::Core::ScalarField->new('stid', [0, 6]),
        Serial::Core::ScalarField->new('date', [6, 11]),
        Serial::Core::ScalarField->new('time', [17, 6]),
        Serial::Core::ScalarField->new('data1', [27, 8]),
        Serial::Core::ScalarField->new('flag1', [35, 1]),
        Serial::Core::ScalarField->new('data2', [36, 8]),
        Serial::Core::ScalarField->new('flag2', [44, 1]),
    );

    open my $stream, '<', 'data.txt';
    my $reader = Serial::Core::FixedWidthReader->new($stream, \@fields);
    while (my $record = $reader->next()) {
        print $record->{'date'}.$/;  
    }

Date/Time Fields
----------------
..  _Time::Piece: http://perldoc.perl.org/Time/Piece.html
..  _strftime: http://linux.die.net/man/3/strftime

A *TimeField* can be used for converting data to a `Time::Piece`_ object. 
A `TimeField` must be initialized with a `strftime`_ format string that will be
used to parse the input. For the sample data, the date and time fields can be
treated as a combined ``DateTime`` field. 

..  code-block:: perl

    my @fields = (
        # Ignoring time zone field. 
        Serial::Core::ScalarField->new('stid', [0, 6]),
        Serial::Core::TimeField->new('timestamp', [6, 17], '%Y-%m-%d %H:%M'),
        Serial::Core::ScalarField->new('data1', [27, 8]),
        Serial::Core::ScalarField->new('flag1', [35, 1]),
        Serial::Core::ScalarField->new('data2', [36, 8]),
        Serial::Core::ScalarField->new('flag2', [44, 1]),
    );

Default Values
--------------

During input all fields in a record are assigned a value. If a field is blank
it is given the default value assigned to that field (`undef` by default). The 
default value should be appropriate to that type, *e.g.* an `TimeField` field 
should not have a string as its default value.

..  code-block:: perl

    my @fields = (
        # Ignoring time zone field. 
        Serial::Core::ScalarField->new('stid', [0, 6]),
        Serial::Core::TimeField->new('timestamp', [6, 17], '%Y-%m-%d %H:%M'),
        Serial::Core::ScalarField->new('data1', [27, 8]),
        Serial::Core::ScalarField->new('flag1', [35, 1], default=>'M'),
        Serial::Core::ScalarField->new('data2', [36, 8]),
        Serial::Core::ScalarField->new('flag2', [44, 1], default=>'M'),
    );


Writing Data
============

Data is written to a stream using a Writer. Writers implement a ``write()`` 
method for writing individual records and a ``dump()`` method for writing a 
sequence of records. Writers use the same field definitions as Readers with
some additional requirements.

With some minor modifications the field definitions for reading the sample data
can be used for writing it. In fact, the modified fields can still be used for
reading the data, so a Reader and a Writer can be defined for a given data
format using one set of field definitions.

..  code-block:: perl

    my @fields = (
        Serial::Core::ScalarField->new('stid', [0, 6]),
        Serial::Core::TimeField->new('timestamp', [6, 17], '%Y-%m-%d %H:%M'),
        Serial::Core::ScalarField->new('timezone', [23, 4], default=>'UTC'),
        Serial::Core::ScalarField->new('data1', [27, 8]),
        Serial::Core::ScalarField->new('flag1', [35, 1], default=>'M'),
        Serial::Core::ScalarField->new('data2', [36, 8]),
        Serial::Core::ScalarField->new('flag2', [44, 1], default=>'M'),
    );

    # Copy 'data.txt' to 'copy.txt'.
    open my $data, '<', 'data.txt';
    open my $copy, '>', 'copy.txt';
    my $reader = Serial::Core::FixedWidthReader->new($data, \@fields);
    my $writer = Serial::Core::FixedWidthWriter->new($copy, \@fields);
    while (my $record = $reader->next()) {
        $writer->write($record);  
    }
    
    # Data can be copied without a loop, but this requires reading the entire 
    # input file into memory.
    my @records = $reader->read();
    $writer->dump(\@records);


Output Formatting
-----------------

..  _format string: http://perldoc.perl.org/functions/sprintf.html

Each field is formatted for output according to its `format string`_. For
fixed-width output values are fit to the allotted fields widths by padding on
the left or trimming on the right. By using a format width, values can be
positioned within the field. Use a format width smaller than the field width to
specify a left margin between fields.

..  code-block:: perl

    my @fields = (
        Serial::Core::ScalarField->new('stid', [0, 6]),
        Serial::Core::TimeField->new('timestamp', [6, 17], '%Y-%m-%d %H:%M'),
        Serial::Core::ScalarField->new('timezone', [23, 4], default=>'UTC'),
        Serial::Core::ScalarField->new('data1', [27, 8], fmt=>'%7.2f'),
        Serial::Core::ScalarField->new('flag1', [35, 1], default=>'M'),
        Serial::Core::ScalarField->new('data2', [36, 8], fmt=>'%7.2f'),
        Serial::Core::ScalarField->new('flag2', [44, 1], default=>'M'),
    );
    
Default Values
--------------
 
For every output record a Writer will write a value for each defined field. If 
a field is missing from a record the Writer will use the default value for that
field (``undef`` is encoded as a blank field). Default output values should be 
type-compatible, *i.e.* don't give a scalar default value to a ``TimeField``.

    

Delimited Data
==============

The ``DelimitedReader`` and ``DelimitedWriter`` classes can be used for reading 
and writing delimited data, e.g. a CSV file.

::

    340010,2012-02-01 00:00,UTC,-999.00,M,-999.00,S
    340010,2012-03-01 00:00,UTC,72.00,,1.23,A
    340010,2012-04-01 00:10,UTC,63.80,Q,0.00,

Delimited fields are defined in the same way as fixed-width fields except that
field positions are given by index (starting at 0). 

..  code-block:: perl

    my @fields = (
        Serial::Core::ScalarField->new('stid', 0),
        Serial::Core::TimeField->new('timestamp', 1, '%Y-%m-%d %H:%M'),
        Serial::Core::ScalarField->new('timezone', 2, default=>'UTC'),
        Serial::Core::ScalarField->new('data1', 3, fmt=>'%7.2f'),
        Serial::Core::ScalarField->new('flag1', 4, default=>'M'),
        Serial::Core::ScalarField->new('data2', 5, fmt=>'%7.2f'),
        Serial::Core::ScalarField->new('flag2', 6, default=>'M'),
    );

    ...
    
    my $delim = ',';
    $reader = Serial::Core::DelimitedReader->new($istream, \@fields, $delim);
    $writer = Serial::Core::DelimitedWriter->new($ostream, \@fields, $delim);


Initializing Readers and Writers
================================

For most situations, calling a class's ``open()`` method is the most convenient
way to create a Reader or Writer. This creates an object that will close its
underlying stream automatically when it goes out of scope. If a string is 
passed to ``open()`` it is interpreted as a path to be opened as a plain text 
file. If another type of stream is needed, open the stream explicitly and pass 
it to ``open()`` instead.

..  code-block:: perl

    {
        # The input stream is closed when $reader is destroyed at the end of
        # this lexical scope.
        my $reader = Serial::Core::DelmitedReader->open('data.csv', \@fields, ',');
        my @records = $reader->read();
    }

Calling a Reader's or Writer's ``new()`` method provides the most control. The
client code is responsible for opening and closing the associated stream. This
method takes the same arguments as ``open()``, except the first argument must
be an open stream handle.


..  code-block:: perl

    open my $stream, '<', 'data.csv';
    my $reader = Serial::Core::DelimitedReader->new($stream, \@fields, ',');
    my @records = $reader->read();
    close $stream;


Filters
=======

Filters are used to manipulate data records after they have been parsed by a
Reader or before they are written by a Writer. A filter is any function, class
method, or callable object that takes a data record as its only argument and 
returns a data record or ``undef`` to reject the record.

..  code-block:: perl

    my $month_filter = sub {
        $ Filter function to restrict data to records from March.
        my ($record) = @_;
        return $record->{'timestamp'}->mon == 3 ? $record : undef;
    };

    ...

    $reader->filter($month_filter);
    my @records = $reader->read();  // read March records only
    
    ...
    
    $writer->filter($month_filter);
    $writer->dump(\@records);  // write March records only
    

Advanced Filtering
------------------

Any callable object can be a filter, including a class that overloads the 
``&{}`` operator.

..  code-block:: perl

    package MonthFilter;
    
    # Filter class to restrict data to a specific month.
    
    use overload '&{}' => \&_func;  # make MonthFilter object callable

    sub new {
        my $class = shift @_;
        my $self = bless {}, $class;
        my ($self->{_month}) = @_;
        return $self;
    }

    sub _func {
        # Return a closure to use as a callback.
        my $self = shift @_;
        return sub {
            my ($record) = @_;
            return return $record->{'timestamp'}->mon == 3 ? $record : undef;
        };
    }
    ...

    $reader->filter(MonthFilter->new(3));  // read March records only


Modifying Records
-----------------

A filter can return a modified version of its input record or a different
record altogether.

..  code-block:: perl

    my $OFFSET = -360;  # CST
    my $local_time = sub {
        # Convert timestamp from UTC to local time.
        my $record = @_;
        $record->{timestamp} += $self->{$OFFSET}*60;
        return $record;
    };
    ...
    $reader->filter($local_time);  # convert from UTC to CST


Multple Filters
---------------

Filters can be chained and are called in order for each record. If any filter
returns ``undef`` the record is immediately dropped. For the best performance 
filters should be ordered from most exclusive (most likely to return ``undef``) 
to least.

..  code-block:: perl

    $reader->filter(MonthFilter->new(3));
    $reader->filter($local_time);
    $reader->filter();  # clear all filters
    $reader->filter(MonthFilter->new(3), $local_time);  # single call

Predefined Filters
------------------

The library includes some filter classes, such as ``FieldFilter``.

..  code-block:: perl

    # Only accept records where the color field is crimson or cream.
    my @colors = ('crimson', 'cream');
    my $whitelist = Serial::Core::FieldFilter->new('color', \@colors);
    
    # Reject all records where the color field is orange.
    my @colors = ('orange');
    $blacklist = Serial::Core::FieldFilter->new('color', \@colors, blacklist=>true);


Tips and Tricks
===============

Quoted Strings
--------------

The ``ScalarField`` type can read and write quoted values by initializing it 
with the quote character to use.

..  code-block:: perl

    Serial::Core::ScalarField->new('name', 0, quote=>'"');  # double-quoted

Nonstandard Line Endings
------------------------

By default, lines of text are assumed to end with the platform-specific line
ending, i.e. ``$/``. Readers expect that ending on each line of text from their
input stream, and writers append it to each line written to their output
stream.  If a different ending is required use use the ``endl`` option.

..  code-block:: perl

    my $ENDL = "\r\r";  // Windows
    my $writer = Serial::Core::FixedWidthWriter->new($stream, \@fields, endl=>$ENDL);

Header Data
-----------

Header data is outside the scope of this library. Client code is responsible
for reading or writing header data from or to the stream before the first
line is read or written. This is typically done by the ``_init()`` method.

Combined Fields
---------------

Filters can be used to map a single field in the input/output stream to/from
multiple fields in the data record, or *vice versa*.

..  code-block:: perl

    sub timestamp_filter {
        # Combine separate 'date' and 'time' fields into a 'timestamp' field.
        my ($record) = $_;
        my $date = $record->{'date'}->strftime('%Y-%m-%d');
        my $time = $record->{'time'}->strftime('%H-%M-%S');
        $record->{'timestamp'} = "${date}T${time}".
        return $record;
    }
