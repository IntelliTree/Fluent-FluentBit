package Fluent::LibFluentBit;
use strict;
use warnings;

# VERSION
# ABSTRACT: Perl interface to libfluent-bit.so

require XSLoader;
XSLoader::load('Fluent::LibFluentBit', $Fluent::LibFluentBit::VERSION);

1;
