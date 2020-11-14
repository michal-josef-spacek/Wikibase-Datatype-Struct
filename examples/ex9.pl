#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use Wikidata::Datatype::Value::String;
use Wikidata::Datatype::Struct::Value::String qw(obj2struct);

# Object.
my $obj = Wikidata::Datatype::Value::String->new(
        'value' => 'foo',
);

# Get structure.
my $struct_hr = obj2struct($obj);

# Dump to output.
p $struct_hr;

# Output:
# \ {
#     type    "string",
#     value   "foo"
# }