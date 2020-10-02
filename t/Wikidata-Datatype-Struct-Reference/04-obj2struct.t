use strict;
use warnings;

use Test::More 'tests' => 3;
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

# Test.
$obj = Wikidata::Datatype::Reference->new(
	'snaks' => [
		Wikidata::Datatype::Snak->new(
			'datatype' => 'url',
			'datavalue' => Wikidata::Datatype::Value::String->new(
				'value' => 'https://skim.cz',
			),
			'property' => 'P93',
		),
		Wikidata::Datatype::Snak->new(
			'datatype' => 'url',
			'datavalue' => Wikidata::Datatype::Value::String->new(
				'value' => 'https://example.com',
			),
			'property' => 'P93',
		),
		Wikidata::Datatype::Snak->new(
			'datatype' => 'string',
			'datavalue' => Wikidata::Datatype::Value::String->new(
				'value' => 'foo',
			),
			'property' => 'P31',
		),
	],
);
$ret_hr = Wikidata::Datatype::Struct::Reference::obj2struct($obj);
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
				}, {
					'datatype' => 'url',
					'datavalue' => {
						'value' => 'https://example.com',
						'type' => 'string',
					},
					'snaktype' => 'value',
					'property' => 'P93',
				},
			],
			'P31' => [
				{
					'datatype' => 'string',
					'datavalue' => {
						'value' => 'foo',
						'type' => 'string',
					},
					'snaktype' => 'value',
					'property' => 'P31',
				},
			],
		},
		'snaks-order' => [
			'P93',
			'P31',
		],
	},
	'Output of obj2struct() subroutine. Multiple values.',
);
