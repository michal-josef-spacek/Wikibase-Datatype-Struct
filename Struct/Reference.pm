package Wikidata::Datatype::Struct::Reference;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;
use Wikidata::Datatype::Reference;
use Wikidata::Datatype::Struct::Utils qw(obj_array_ref2struct struct2snaks_array_ref);

Readonly::Array our @EXPORT_OK => qw(obj2struct struct2obj);

our $VERSION = 0.01;

sub obj2struct {
	my ($obj, $base_uri) = @_;

	if (! $obj->isa('Wikidata::Datatype::Reference')) {
		err "Object isn't 'Wikidata::Datatype::Reference'.";
	}

	my $struct_hr = obj_array_ref2struct($obj->snaks, 'snaks', $base_uri);

	return $struct_hr;
}

sub struct2obj {
	my $struct_hr = shift;

	my $obj = Wikidata::Datatype::Reference->new(
		'snaks' => struct2snaks_array_ref($struct_hr, 'snaks'),
	);

	return $obj;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Wikidata::Datatype::Struct::Reference - Wikidata reference structure serialization.

=head1 SYNOPSIS

 use Wikidata::Datatype::Struct::Reference qw(obj2struct struct2obj);

 my $struct_hr = obj2struct($obj);
 my $obj = struct2obj($struct_hr);

=head1 DESCRIPTION

This conversion is between objects defined in Wikidata::Datatype and structures
serialized via JSON to MediaWiki.

=head1 SUBROUTINES

=head2 C<obj2struct>

 my $struct_hr = obj2struct($obj);

Convert Wikidata::Datatype::Reference instance to structure.

Returns reference to hash with structure.

=head2 C<struct2obj>

 my $obj = struct2obj($struct_hr);

Convert structure of reference to object.

Returns Wikidata::Datatype::Reference instance.

=head1 ERRORS

 obj2struct():
         Object isn't 'Wikidata::Datatype::Reference'.

=head1 EXAMPLE1

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

=head1 EXAMPLE2

 use strict;
 use warnings;

 use Wikidata::Datatype::Struct::Reference qw(struct2obj);

 # Item structure.
 my $struct_hr = {
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
 };

 # Get object.
 my $obj = struct2obj($struct_hr);

 # Get value.
 my $snaks_ar = $obj->snaks;

 # Print out number of snaks.
 print "Number of snaks: ".@{$snaks_ar}."\n";

 # Output:
 # Number of snaks: 3

=head1 DEPENDENCIES

L<Error::Pure>,
L<Exporter>,
L<Readonly>,
L<Wikidata::Datatype::Reference>,
L<Wikidata::Datatype::Struct::Utils>.

=head1 SEE ALSO

=over

=item L<Wikidata::Datatype::Struct>

Wikidata structure serialization.

=item L<Wikidata::Datatype::Reference>

Wikidata reference datatype.

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
