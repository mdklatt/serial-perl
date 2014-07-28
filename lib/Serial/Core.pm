package Serial::Core;

use 5.008;
use strict;
use warnings;

our $VERSION = eval '0.001'; 

use Serial::Core::ScalarField;
use Serial::Core::DelimitedReader;
use Serial::Core::FixedWidthReader;
use Serial::Core::FieldFilter;
use Serial::Core::RangeFilter;

1;
