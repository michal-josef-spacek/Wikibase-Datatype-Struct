#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use Wikidata::Datatype::Value::Monolingual;
use Wikidata::Datatype::Struct::Value::Monolingual qw(obj2struct);

# Object.
my $obj = Wikidata::Datatype::Value::Monolingual->new(
        'language' => 'en',
        'value' => 'English text',
);

# Get structure.
my $struct_hr = obj2struct($obj);

# Dump to output.
p $struct_hr;

# Output:
# \ {
#     type    "monolingualtext",
#     value   {
#         language   "en",
#         text       "English text"
#     }
# }