#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use Wikidata::Datatype::Snak;
use Wikidata::Datatype::Struct::Utils qw(obj_array_ref2struct);
use Wikidata::Datatype::Value::Item;
use Wikidata::Datatype::Value::String;

my $snak1 = Wikidata::Datatype::Snak->new(
        'datatype' => 'wikibase-item',
        'datavalue' => Wikidata::Datatype::Value::Item->new(
                'value' => 'Q5',
        ),
        'property' => 'P31',
);
my $snak2 = Wikidata::Datatype::Snak->new(
        'datatype' => 'math',
        'datavalue' => Wikidata::Datatype::Value::String->new(
                'value' => 'E = m c^2',
        ),
        'property' => 'P2534',
);

# Convert list of snak objects to structure.
my $snaks_ar = obj_array_ref2struct([$snak1, $snak2], 'snaks',
        'http://test.wikidata.org/entity/');

# Dump to output.
p $snaks_ar;

# Output:
# \ {
#     snaks         {
#         P31     [
#             [0] {
#                 datatype    "wikibase-item",
#                 datavalue   {
#                     type    "wikibase-entityid",
#                     value   {
#                         entity-type   "item",
#                         id            "Q5",
#                         numeric-id    5
#                     }
#                 },
#                 property    "P31",
#                 snaktype    "value"
#             }
#         ],
#         P2534   [
#             [0] {
#                 datatype    "math",
#                 datavalue   {
#                     type    "string",
#                     value   "E = m c^2"
#                 },
#                 property    "P2534",
#                 snaktype    "value"
#             }
#         ]
#     },
#     snaks-order   [
#         [0] "P31",
#         [1] "P2534"
#     ]
# }