#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use Wikidata::Datatype::Value::Item;
use Wikidata::Datatype::Struct::Value::Item qw(obj2struct);

# Object.
my $obj = Wikidata::Datatype::Value::Item->new(
        'value' => 'Q123',
);

# Get structure.
my $struct_hr = obj2struct($obj);

# Dump to output.
p $struct_hr;

# Output:
# \ {
#     type    "wikibase-entityid",
#     value   {
#         entity-type   "item",
#         id            "Q123",
#         numeric-id    123
#     }
# }