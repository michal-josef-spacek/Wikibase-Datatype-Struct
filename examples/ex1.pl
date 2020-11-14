#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use Wikidata::Datatype::Reference;
use Wikidata::Datatype::Snak;
use Wikidata::Datatype::Struct::Reference qw(obj2struct);
use Wikidata::Datatype::Value::Item;
use Wikidata::Datatype::Value::String;
use Wikidata::Datatype::Value::Time;

# Object.
# instance of (P31) human (Q5)
my $obj = Wikidata::Datatype::Reference->new(
         'snaks' => [
                 # stated in (P248) Virtual International Authority File (Q53919)
                 Wikidata::Datatype::Snak->new(
                          'datatype' => 'wikibase-item',
                          'datavalue' => Wikidata::Datatype::Value::Item->new(
                                  'value' => 'Q53919',
                          ),
                          'property' => 'P248',
                 ),

                 # VIAF ID (P214) 113230702
                 Wikidata::Datatype::Snak->new(
                          'datatype' => 'external-id',
                          'datavalue' => Wikidata::Datatype::Value::String->new(
                                  'value' => '113230702',
                          ),
                          'property' => 'P214',
                 ),

                 # retrieved (P813) 7 December 2013
                 Wikidata::Datatype::Snak->new(
                          'datatype' => 'time',
                          'datavalue' => Wikidata::Datatype::Value::Time->new(
                                  'value' => '+2013-12-07T00:00:00Z',
                          ),
                          'property' => 'P813',
                 ),
         ],
);

# Get structure.
my $struct_hr = obj2struct($obj, 'http://test.wikidata.org/entity/');

# Dump to output.
p $struct_hr;

# Output:
# \ {
#     snaks         {
#         P214   [
#             [0] {
#                 datatype    "external-id",
#                 datavalue   {
#                     type    "string",
#                     value   113230702
#                 },
#                 property    "P214",
#                 snaktype    "value"
#             }
#         ],
#         P248   [
#             [0] {
#                 datatype    "wikibase-item",
#                 datavalue   {
#                     type    "wikibase-entityid",
#                     value   {
#                         entity-type   "item",
#                         id            "Q53919",
#                         numeric-id    53919
#                     }
#                 },
#                 property    "P248",
#                 snaktype    "value"
#             }
#         ],
#         P813   [
#             [0] {
#                 datatype    "time",
#                 datavalue   {
#                     type    "time",
#                     value   {
#                         after           0,
#                         before          0,
#                         calendarmodel   "http://test.wikidata.org/entity/Q1985727",
#                         precision       11,
#                         time            "+2013-12-07T00:00:00Z",
#                         timezone        0
#                     }
#                 },
#                 property    "P813",
#                 snaktype    "value"
#             }
#         ]
#     },
#     snaks-order   [
#         [0] "P248",
#         [1] "P214",
#         [2] "P813"
#     ]
# }