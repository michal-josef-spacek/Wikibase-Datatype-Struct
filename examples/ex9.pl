#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use Wikidata::Datatype::Statement;
use Wikidata::Datatype::Struct::Statement qw(obj2struct);

# Object.
my $obj = Wikidata::Datatype::Statement->new(
        # instance of (P31) human (Q5)
        'snak' => Wikidata::Datatype::Snak->new(
                 'datatype' => 'wikibase-item',
                 'datavalue' => Wikidata::Datatype::Value::Item->new(
                         'value' => 'Q5',
                 ),
                 'property' => 'P31',
        ),
        'property_snaks' => [
                # of (P642) alien (Q474741)
                Wikidata::Datatype::Snak->new(
                         'datatype' => 'wikibase-item',
                         'datavalue' => Wikidata::Datatype::Value::Item->new(
                                 'value' => 'Q474741',
                         ),
                         'property' => 'P642',
                ),
        ],
        'references' => [
                 Wikidata::Datatype::Reference->new(
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
                 ),
        ],
);

# Get structure.
my $struct_hr = obj2struct($obj, 'http://test.wikidata.org/entity/');

# Dump to output.
p $struct_hr;

# Output:
# \ {
#     mainsnak           {
#         datatype    "wikibase-item",
#         datavalue   {
#             type    "wikibase-entityid",
#             value   {
#                 entity-type   "item",
#                 id            "Q5",
#                 numeric-id    5
#             }
#         },
#         property    "P31",
#         snaktype    "value"
#     },
#     qualifiers         {
#         P642   [
#             [0] {
#                 datatype    "wikibase-item",
#                 datavalue   {
#                     type    "wikibase-entityid",
#                     value   {
#                         entity-type   "item",
#                         id            "Q474741",
#                         numeric-id    474741
#                     }
#                 },
#                 property    "P642",
#                 snaktype    "value"
#             }
#         ]
#     },
#     qualifiers-order   [
#         [0] "P642"
#     ],
#     rank               "normal",
#     references         [
#         [0] {
#             snaks         {
#                 P214   [
#                     [0] {
#                         datatype    "external-id",
#                         datavalue   {
#                             type    "string",
#                             value   113230702
#                         },
#                         property    "P214",
#                         snaktype    "value"
#                     }
#                 ],
#                 P248   [
#                     [0] {
#                         datatype    "wikibase-item",
#                         datavalue   {
#                             type    "wikibase-entityid",
#                             value   {
#                                 entity-type   "item",
#                                 id            "Q53919",
#                                 numeric-id    53919
#                             }
#                         },
#                         property    "P248",
#                         snaktype    "value"
#                     }
#                 ],
#                 P813   [
#                     [0] {
#                         datatype    "time",
#                         datavalue   {
#                             type    "time",
#                             value   {
#                                 after           0,
#                                 before          0,
#                                 calendarmodel   "http://test.wikidata.org/entity/Q1985727",
#                                 precision       11,
#                                 time            "+2013-12-07T00:00:00Z",
#                                 timezone        0
#                             }
#                         },
#                         property    "P813",
#                         snaktype    "value"
#                     }
#                 ]
#             },
#             snaks-order   [
#                 [0] "P248",
#                 [1] "P214",
#                 [2] "P813"
#             ]
#         }
#     ],
#     type               "statement"
# }