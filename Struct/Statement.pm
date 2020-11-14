package Wikidata::Datatype::Struct::Statement;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;
use Wikidata::Datatype::Statement;
use Wikidata::Datatype::Struct::Reference;
use Wikidata::Datatype::Struct::Snak;
use Wikidata::Datatype::Struct::Utils qw(obj_array_ref2struct struct2snaks_array_ref);

Readonly::Array our @EXPORT_OK => qw(obj2struct struct2obj);

our $VERSION = 0.01;

sub obj2struct {
	my ($obj, $base_uri) = @_;

	if (! $obj->isa('Wikidata::Datatype::Statement')) {
		err "Object isn't 'Wikidata::Datatype::Statement'.";
	}

	my $struct_hr = {
		'mainsnak' => Wikidata::Datatype::Struct::Snak::obj2struct($obj->snak, $base_uri),
		@{$obj->property_snaks} ? (
			%{obj_array_ref2struct($obj->property_snaks, 'qualifiers')},
		) : (),
		'rank' => $obj->rank,
		@{$obj->references} ? (
			'references' => [
				map { Wikidata::Datatype::Struct::Reference::obj2struct($_, $base_uri); }
				@{$obj->references},
			],
		) : (),
		'type' => 'statement',
	};

	return $struct_hr;
}

sub struct2obj {
	my $struct_hr = shift;

	my $obj = Wikidata::Datatype::Statement->new(
		'property_snaks' => struct2snaks_array_ref($struct_hr, 'qualifiers'),
		'snak' => Wikidata::Datatype::Struct::Snak::struct2obj($struct_hr->{'mainsnak'}),
		'references' => [
			map { Wikidata::Datatype::Struct::Reference::struct2obj($_) }
			@{$struct_hr->{'references'}}
		],
		'rank' => $struct_hr->{'rank'},
	);

	return $obj;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Wikidata::Datatype::Struct::Statement - Wikidata statement structure serialization.

=head1 SYNOPSIS

 use Wikidata::Datatype::Struct::Statement qw(obj2struct struct2obj);

 my $struct_hr = obj2struct($obj);
 my $obj = struct2obj($struct_hr);

=head1 DESCRIPTION

This conversion is between objects defined in Wikidata::Datatype and structures
serialized via JSON to MediaWiki.

=head1 SUBROUTINES

=head2 C<obj2struct>

 my $struct_hr = obj2struct($obj);

Convert Wikidata::Datatype::Statement instance to structure.

Returns reference to hash with structure.

=head2 C<struct2obj>

 my $obj = struct2obj($struct_hr);

Convert structure of statement to object.

Returns Wikidata::Datatype::Statement instance.

=head1 ERRORS

 obj2struct():
         Object isn't 'Wikidata::Datatype::Statement'.

=head1 EXAMPLE1

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

=head1 EXAMPLE2

 use strict;
 use warnings;

 use Wikidata::Datatype::Struct::Statement qw(struct2obj);

 # Item structure.
 my $struct_hr = {
         'mainsnak' => {
                 'datatype' => 'wikibase-item',
                 'datavalue' => {
                         'type' => 'wikibase-entityid',
                         'value' => {
                                 'entity-type' => 'item',
                                 'id' => 'Q5',
                                 'numeric-id' => 5,
                         },
                 },
                 'property' => 'P31',
                 'snaktype' => 'value',
         },
         'qualifiers' => {
                 'P642' => [{
                         'datatype' => 'wikibase-item',
                         'datavalue' => {
                                 'type' => 'wikibase-entityid',
                                 'value' => {
                                         'entity-type' => 'item',
                                         'id' => 'Q474741',
                                         'numeric-id' => 474741,
                                 },
                         },
                         'property' => 'P642',
                         'snaktype' => 'value',
                 }],
         },
         'qualifiers-order' => [
                 'P642',
         ],
         'rank' => 'normal',
         'references' => [{
                 'snaks' => {
                         'P214' => [{
                                 'datatype' => 'external-id',
                                 'datavalue' => {
                                         'type' => 'string',
                                         'value' => '113230702',
                                 },
                                 'property' => 'P214',
                                 'snaktype' => 'value',
                         }],
                         'P248' => [{
                                 'datatype' => 'wikibase-item',
                                 'datavalue' => {
                                         'type' => 'wikibase-entityid',
                                         'value' => {
                                                 'entity-type' => 'item',
                                                 'id' => 'Q53919',
                                                 'numeric-id' => 53919,
                                         },
                                 },
                                 'property' => 'P248',
                                 'snaktype' => 'value',
                         }],
                         'P813' => [{
                                 'datatype' => 'time',
                                 'datavalue' => {
                                         'type' => 'time',
                                         'value' => {
                                                 'after' => 0,
                                                 'before' => 0,
                                                 'calendarmodel' => 'http://test.wikidata.org/entity/Q1985727',
                                                 'precision' => 11,
                                                 'time' => '+2013-12-07T00:00:00Z',
                                                 'timezone' => 0,
                                         },
                                 },
                                 'property' => 'P813',
                                 'snaktype' => 'value',
                         }],
                 },
                 'snaks-order' => [
                         'P248',
                         'P214',
                         'P813',
                 ],
         }],
         'type' => 'statement',
 };

 # Get object.
 my $obj = struct2obj($struct_hr);

 print 'Claim: '.$obj->snak->property.' -> '.$obj->snak->datavalue->value."\n";
 print "Qualifiers:\n";
 foreach my $property_snak (@{$obj->property_snaks}) {
         print "\t".$property_snak->property.' -> '.
                 $property_snak->datavalue->value."\n";
 }
 print "References:\n";
 foreach my $reference (@{$obj->references}) {
         print "\tReference:\n";
         foreach my $reference_snak (@{$reference->snaks}) {
                 print "\t\t".$reference_snak->property.' -> '.
                         $reference_snak->datavalue->value."\n";
         }
 }
 print 'Rank: '.$obj->rank."\n";

 # Output:
 # Claim: P31 -> Q5
 # Qualifiers:
 #         P642 -> Q474741
 # References:
 #         Reference:
 #                 P248 -> Q53919
 #                 P214 -> 113230702
 #                 P813 -> +2013-12-07T00:00:00Z
 # Rank: normal

=head1 DEPENDENCIES

L<Error::Pure>,
L<Exporter>,
L<Readonly>,
L<Wikidata::Datatype::Statement>,
L<Wikidata::Datatype::Struct::Reference>,
L<Wikidata::Datatype::Struct::Snak>,
L<Wikidata::Datatype::Struct::Utils>.

=head1 SEE ALSO

=over

=item L<Wikidata::Datatype::Struct>

Wikidata structure serialization.

=item L<Wikidata::Datatype::Statement>

Wikidata statement datatype.

=back

=head1 REPOSITORY

L<https://github.com/michal-josef-spacek/Wikidata-Datatype-Struct>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© Michal Josef Špaček 2020

BSD 2-Clause License

=head1 VERSION

0.01

=cut
