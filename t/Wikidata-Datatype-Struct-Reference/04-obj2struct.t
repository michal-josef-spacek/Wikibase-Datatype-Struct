use strict;
use warnings;

use Test::More 'tests' => 2;
use Test::NoWarnings;
use Unicode::UTF8 qw(decode_utf8);
use Wikidata::Datatype::Reference;
use Wikidata::Datatype::Snak;
use Wikidata::Datatype::Value::String;
use Wikidata::Datatype::Struct::Reference;

# Test.
my $obj = Wikidata::Datatype::Reference->new(
	'snaks' => [
		Wikidata::Datatype::Snak->new(
			'datatype' => 'url',
			'datavalue' => Wikidata::Datatype::Value::String->new(
				'value' => 'https://skim.cz',
			),
			'property' => 'P93',
		),
	],
);
my $ret_hr = Wikidata::Datatype::Struct::Reference::obj2struct($obj);
is_deeply(
	$ret_hr,
	{
		'snaks' => {
			'P93' => [
				{
					'datatype' => 'url',
					'datavalue' => {
						'value' => 'https://skim.cz',
						'type' => 'string',
					},
					'snaktype' => 'value',
					'property' => 'P93',
				},
			],
		},
		'snaks-order' => [
			'P93',
		],
	},
	'Output of obj2struct() subroutine.',
);
