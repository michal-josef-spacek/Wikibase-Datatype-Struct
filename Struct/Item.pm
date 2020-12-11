package Wikibase::Datatype::Struct::Item;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;
use Wikibase::Datatype::Item;
use Wikibase::Datatype::Struct::Sitelink;
use Wikibase::Datatype::Struct::Statement;
use Wikibase::Datatype::Struct::Value::Monolingual;

Readonly::Array our @EXPORT_OK => qw(obj2struct struct2obj);

our $VERSION = 0.01;

sub obj2struct {
	my ($obj, $base_uri) = @_;

	if (! $obj->isa('Wikibase::Datatype::Item')) {
		err "Object isn't 'Wikibase::Datatype::Item'.";
	}
	if (! defined $base_uri) {
		err 'Base URI is required.';
	}

	my $struct_hr = {
		'type' => 'item',
	};

	# Aliases.
	foreach my $alias (@{$obj->aliases}) {
		if (! exists $struct_hr->{'aliases'}->{$alias->language}) {
			$struct_hr->{'aliases'}->{$alias->language} = [];
		}
		push @{$struct_hr->{'aliases'}->{$alias->language}}, {
			'language' => $alias->language,
			'value' => $alias->value,
		}
	}

	# Claims.
	foreach my $statement (@{$obj->statements}) {
		$struct_hr->{'statements'}->{$statement->snak->property} //= [];
		push @{$struct_hr->{'statements'}->{$statement->snak->property}},
			Wikibase::Datatype::Struct::Statement::obj2struct($statement, $base_uri);
	}

	# Descriptions.
	foreach my $desc (@{$obj->descriptions}) {
		$struct_hr->{'descriptions'}->{$desc->language} = {
			'language' => $desc->language,
			'value' => $desc->value,
		};
	}

	# Id.
	if (defined $obj->id) {
		$struct_hr->{'id'} = $obj->id;
	}

	# Labels.
	foreach my $label (@{$obj->labels}) {
		$struct_hr->{'labels'}->{$label->language} = {
			'language' => $label->language,
			'value' => $label->value,
		};
	}
	
	# Last revision id.
	if (defined $obj->lastrevid) {
		$struct_hr->{'lastrevid'} = $obj->lastrevid;
	}

	# Modified date.
	if (defined $obj->modified) {
		$struct_hr->{'modified'} = $obj->modified;
	}

	# Namespace.
	if (defined $obj->ns) {
		$struct_hr->{'ns'} = $obj->ns;
	}

	# Page ID.
	if (defined $obj->page_id) {
		$struct_hr->{'pageid'} = $obj->page_id;
	}

	# Sitelinks.
	foreach my $sitelink (@{$obj->sitelinks}) {
		$struct_hr->{'sitelinks'}->{$sitelink->site}
			= Wikibase::Datatype::Struct::Sitelink::obj2struct($sitelink);
	}

	# Title.
	if (defined $obj->title) {
		$struct_hr->{'title'} = $obj->title;
	}

	return $struct_hr;
}

sub struct2obj {
	my $struct_hr = shift;

	if (! exists $struct_hr->{'type'} || $struct_hr->{'type'} ne 'item') {
		err "Structure isn't for 'item' type.";
	}

	# TODO
	my $obj = Wikibase::Datatype::Item->new(
		'aliases' => [],
		'descriptions' => [],
		'labels' => [],
		'lastrevid' => '',
		'modified' => '',
		'ns' => '',
		'sitelinks' => [],
		'statements' => [],
		'title' => '',
	);

	return $obj;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Wikibase::Datatype::Struct::Item - Wikibase item structure serialization.

=head1 SYNOPSIS

 use Wikibase::Datatype::Struct::Item qw(obj2struct struct2obj);

 my $struct_hr = obj2struct($obj, $base_uri);
 my $obj = struct2obj($struct_hr);

=head1 DESCRIPTION

This conversion is between objects defined in Wikibase::Datatype and structures
serialized via JSON to MediaWiki.

=head1 SUBROUTINES

=head2 C<obj2struct>

 my $struct_hr = obj2struct($obj, $base_uri);

Convert Wikibase::Datatype::Item instance to structure.
C<$base_uri> is base URI of Wikibase system (e.g. http://test.wikidata.org/entity/).

Returns reference to hash with structure.

=head2 C<struct2obj>

 my $obj = struct2obj($struct_hr);

Convert structure of item to object.

Returns Wikibase::Datatype::Item instance.

=head1 ERRORS

 obj2struct():
         Base URI is required.
         Object isn't 'Wikibase::Datatype::Item'.

=head1 EXAMPLE1

 use strict;
 use warnings;

 use Data::Printer;
 use Wikibase::Datatype::Item;
 use Wikibase::Datatype::Reference;
 use Wikibase::Datatype::Sitelink;
 use Wikibase::Datatype::Snak;
 use Wikibase::Datatype::Statement;
 use Wikibase::Datatype::Struct::Item qw(obj2struct);
 use Wikibase::Datatype::Value::Item;
 use Wikibase::Datatype::Value::Monolingual;
 use Wikibase::Datatype::Value::String;
 use Wikibase::Datatype::Value::Time;

 # Object.
 my $statement1 = Wikibase::Datatype::Statement->new(
         # instance of (P31) human (Q5)
         'snak' => Wikibase::Datatype::Snak->new(
                  'datatype' => 'wikibase-item',
                  'datavalue' => Wikibase::Datatype::Value::Item->new(
                          'value' => 'Q5',
                  ),
                  'property' => 'P31',
         ),
         'property_snaks' => [
                 # of (P642) alien (Q474741)
                 Wikibase::Datatype::Snak->new(
                          'datatype' => 'wikibase-item',
                          'datavalue' => Wikibase::Datatype::Value::Item->new(
                                  'value' => 'Q474741',
                          ),
                          'property' => 'P642',
                 ),
         ],
         'references' => [
                  Wikibase::Datatype::Reference->new(
                          'snaks' => [
                                  # stated in (P248) Virtual International Authority File (Q53919)
                                  Wikibase::Datatype::Snak->new(
                                           'datatype' => 'wikibase-item',
                                           'datavalue' => Wikibase::Datatype::Value::Item->new(
                                                   'value' => 'Q53919',
                                           ),
                                           'property' => 'P248',
                                  ),

                                  # VIAF ID (P214) 113230702
                                  Wikibase::Datatype::Snak->new(
                                           'datatype' => 'external-id',
                                           'datavalue' => Wikibase::Datatype::Value::String->new(
                                                   'value' => '113230702',
                                           ),
                                           'property' => 'P214',
                                  ),

                                  # retrieved (P813) 7 December 2013
                                  Wikibase::Datatype::Snak->new(
                                           'datatype' => 'time',
                                           'datavalue' => Wikibase::Datatype::Value::Time->new(
                                                   'value' => '+2013-12-07T00:00:00Z',
                                           ),
                                           'property' => 'P813',
                                  ),
                          ],
                  ),
         ],
 );
 my $statement2 = Wikibase::Datatype::Statement->new(
         # sex or gender (P21) male (Q6581097)
         'snak' => Wikibase::Datatype::Snak->new(
                  'datatype' => 'wikibase-item',
                  'datavalue' => Wikibase::Datatype::Value::Item->new(
                          'value' => 'Q6581097',
                  ),
                  'property' => 'P21',
         ),
         'references' => [
                  Wikibase::Datatype::Reference->new(
                          'snaks' => [
                                  # stated in (P248) Virtual International Authority File (Q53919)
                                  Wikibase::Datatype::Snak->new(
                                           'datatype' => 'wikibase-item',
                                           'datavalue' => Wikibase::Datatype::Value::Item->new(
                                                   'value' => 'Q53919',
                                           ),
                                           'property' => 'P248',
                                  ),

                                  # VIAF ID (P214) 113230702
                                  Wikibase::Datatype::Snak->new(
                                           'datatype' => 'external-id',
                                           'datavalue' => Wikibase::Datatype::Value::String->new(
                                                   'value' => '113230702',
                                           ),
                                           'property' => 'P214',
                                  ),

                                  # retrieved (P813) 7 December 2013
                                  Wikibase::Datatype::Snak->new(
                                           'datatype' => 'time',
                                           'datavalue' => Wikibase::Datatype::Value::Time->new(
                                                   'value' => '+2013-12-07T00:00:00Z',
                                           ),
                                           'property' => 'P813',
                                  ),
                          ],
                  ),
         ],
 );

 # Main item.
 my $obj = Wikibase::Datatype::Item->new(
         'aliases' => [
                 Wikibase::Datatype::Value::Monolingual->new(
                         'language' => 'cs',
                         'value' => 'Douglas Noël Adams',
                 ),
                 Wikibase::Datatype::Value::Monolingual->new(
                         'language' => 'cs',
                         'value' => 'Douglas Noel Adams',
                 ),
                 Wikibase::Datatype::Value::Monolingual->new(
                         'language' => 'cs',
                         'value' => 'Douglas N. Adams',
                 ),
                 Wikibase::Datatype::Value::Monolingual->new(
                         'language' => 'en',
                         'value' => 'Douglas Noel Adams',
                 ),
                 Wikibase::Datatype::Value::Monolingual->new(
                         'language' => 'en',
                         'value' => 'Douglas Noël Adams',
                 ),
                 Wikibase::Datatype::Value::Monolingual->new(
                         'language' => 'en',
                         'value' => 'Douglas N. Adams',
                 ),
         ],
         'descriptions' => [
                 Wikibase::Datatype::Value::Monolingual->new(
                         'language' => 'cs',
                         'value' => 'anglický spisovatel, humorista a dramatik',
                 ),
                 Wikibase::Datatype::Value::Monolingual->new(
                         'language' => 'en',
                         'value' => 'English writer and humorist',
                 ),
         ],
         'id' => 'Q42',
         'labels' => [
                 Wikibase::Datatype::Value::Monolingual->new(
                         'language' => 'cs',
                         'value' => 'Douglas Adams',
                 ),
                 Wikibase::Datatype::Value::Monolingual->new(
                         'language' => 'en',
                         'value' => 'Douglas Adams',
                 ),
         ],
         'page_id' => 123,
         'sitelinks' => [
                 Wikibase::Datatype::Sitelink->new(
                         'site' => 'cswiki',
                         'title' => 'Douglas Adams',
                 ),
                 Wikibase::Datatype::Sitelink->new(
                         'site' => 'enwiki',
                         'title' => 'Douglas Adams',
                 ),
         ],
         'statements' => [
                 $statement1,
                 $statement2,
         ],
         'title' => 'Q42',
 );

 # Get structure.
 my $struct_hr = obj2struct($obj, 'http://test.wikidata.org/entity/');

 # Dump to output.
 p $struct_hr;

 # Output:
 # \ {
 #     aliases        {
 #         cs   [
 #             [0] {
 #                 language   "cs",
 #                 value      "Douglas Noël Adams"
 #             },
 #             [1] {
 #                 language   "cs",
 #                 value      "Douglas Noel Adams"
 #             },
 #             [2] {
 #                 language   "cs",
 #                 value      "Douglas N. Adams"
 #             }
 #         ],
 #         en   [
 #             [0] {
 #                 language   "en",
 #                 value      "Douglas Noel Adams"
 #             },
 #             [1] {
 #                 language   "en",
 #                 value      "Douglas Noël Adams"
 #             },
 #             [2] {
 #                 language   "en",
 #                 value      "Douglas N. Adams"
 #             }
 #         ]
 #     },
 #     descriptions   {
 #         cs   {
 #             language   "cs",
 #             value      "anglický spisovatel, humorista a dramatik"
 #         },
 #         en   {
 #             language   "en",
 #             value      "English writer and humorist"
 #         }
 #     },
 #     id             "Q42",
 #     labels         {
 #         cs   {
 #             language   "cs",
 #             value      "Douglas Adams"
 #         },
 #         en   {
 #             language   "en",
 #             value      "Douglas Adams"
 #         }
 #     },
 #     ns             0,
 #     pageid         123,
 #     sitelinks      {
 #         cswiki   {
 #             badges   [],
 #             site     "cswiki",
 #             title    "Douglas Adams"
 #         },
 #         enwiki   {
 #             badges   [],
 #             site     "enwiki",
 #             title    "Douglas Adams"
 #         }
 #     },
 #     statements     {
 #         P21   [
 #             [0] {
 #                 mainsnak     {
 #                     datatype    "wikibase-item",
 #                     datavalue   {
 #                         type    "wikibase-entityid",
 #                         value   {
 #                             entity-type   "item",
 #                             id            "Q6581097",
 #                             numeric-id    6581097
 #                         }
 #                     },
 #                     property    "P21",
 #                     snaktype    "value"
 #                 },
 #                 rank         "normal",
 #                 references   [
 #                     [0] {
 #                         snaks         {
 #                             P214   [
 #                                 [0] {
 #                                     datatype    "external-id",
 #                                     datavalue   {
 #                                         type    "string",
 #                                         value   113230702
 #                                     },
 #                                     property    "P214",
 #                                     snaktype    "value"
 #                                 }
 #                             ],
 #                             P248   [
 #                                 [0] {
 #                                     datatype    "wikibase-item",
 #                                     datavalue   {
 #                                         type    "wikibase-entityid",
 #                                         value   {
 #                                             entity-type   "item",
 #                                             id            "Q53919",
 #                                             numeric-id    53919
 #                                         }
 #                                     },
 #                                     property    "P248",
 #                                     snaktype    "value"
 #                                 }
 #                             ],
 #                             P813   [
 #                                 [0] {
 #                                     datatype    "time",
 #                                     datavalue   {
 #                                         type    "time",
 #                                         value   {
 #                                             after           0,
 #                                             before          0,
 #                                             calendarmodel   "http://test.wikidata.org/entity/Q1985727",
 #                                             precision       11,
 #                                             time            "+2013-12-07T00:00:00Z",
 #                                             timezone        0
 #                                         }
 #                                     },
 #                                     property    "P813",
 #                                     snaktype    "value"
 #                                 }
 #                             ]
 #                         },
 #                         snaks-order   [
 #                             [0] "P248",
 #                             [1] "P214",
 #                             [2] "P813"
 #                         ]
 #                     }
 #                 ],
 #                 type         "statement"
 #             }
 #         ],
 #         P31   [
 #             [0] {
 #                 mainsnak           {
 #                     datatype    "wikibase-item",
 #                     datavalue   {
 #                         type    "wikibase-entityid",
 #                         value   {
 #                             entity-type   "item",
 #                             id            "Q5",
 #                             numeric-id    5
 #                         }
 #                     },
 #                     property    "P31",
 #                     snaktype    "value"
 #                 },
 #                 qualifiers         {
 #                     P642   [
 #                         [0] {
 #                             datatype    "wikibase-item",
 #                             datavalue   {
 #                                 type    "wikibase-entityid",
 #                                 value   {
 #                                     entity-type   "item",
 #                                     id            "Q474741",
 #                                     numeric-id    474741
 #                                 }
 #                             },
 #                             property    "P642",
 #                             snaktype    "value"
 #                         }
 #                     ]
 #                 },
 #                 qualifiers-order   [
 #                     [0] "P642"
 #                 ],
 #                 rank               "normal",
 #                 references         [
 #                     [0] {
 #                         snaks         {
 #                             P214   [
 #                                 [0] {
 #                                     datatype    "external-id",
 #                                     datavalue   {
 #                                         type    "string",
 #                                         value   113230702
 #                                     },
 #                                     property    "P214",
 #                                     snaktype    "value"
 #                                 }
 #                             ],
 #                             P248   [
 #                                 [0] {
 #                                     datatype    "wikibase-item",
 #                                     datavalue   {
 #                                         type    "wikibase-entityid",
 #                                         value   {
 #                                             entity-type   "item",
 #                                             id            "Q53919",
 #                                             numeric-id    53919
 #                                         }
 #                                     },
 #                                     property    "P248",
 #                                     snaktype    "value"
 #                                 }
 #                             ],
 #                             P813   [
 #                                 [0] {
 #                                     datatype    "time",
 #                                     datavalue   {
 #                                         type    "time",
 #                                         value   {
 #                                             after           0,
 #                                             before          0,
 #                                             calendarmodel   "http://test.wikidata.org/entity/Q1985727",
 #                                             precision       11,
 #                                             time            "+2013-12-07T00:00:00Z",
 #                                             timezone        0
 #                                         }
 #                                     },
 #                                     property    "P813",
 #                                     snaktype    "value"
 #                                 }
 #                             ]
 #                         },
 #                         snaks-order   [
 #                             [0] "P248",
 #                             [1] "P214",
 #                             [2] "P813"
 #                         ]
 #                     }
 #                 ],
 #                 type               "statement"
 #             }
 #         ]
 #     },
 #     title          "Q42",
 #     type           "item"
 # }

=head1 EXAMPLE2

 use strict;
 use warnings;

 use Wikibase::Datatype::Struct::Item qw(struct2obj);

 # Item structure.
 my $struct_hr = {
 # TODO
 };

 # Get object.
 my $obj = struct2obj($struct_hr);

 # TODO

 # Output:
 # TODO

=head1 DEPENDENCIES

L<Error::Pure>,
L<Exporter>,
L<Readonly>,
L<Wikibase::Datatype::Reference>,
L<Wikibase::Datatype::Struct::Utils>.

=head1 SEE ALSO

=over

=item L<Wikibase::Datatype::Struct>

Wikibase structure serialization.

=item L<Wikibase::Datatype::Item>

Wikibase item datatype.

=back

=head1 REPOSITORY

L<https://github.com/michal-josef-spacek/Wikibase-Datatype-Struct>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© Michal Josef Špaček 2020

BSD 2-Clause License

=head1 VERSION

0.01

=cut
