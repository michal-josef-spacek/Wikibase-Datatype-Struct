use strict;
use warnings;

use Test::More 'tests' => 2;
use Test::NoWarnings;
use Wikidata::Datatype::Snak;
use Wikidata::Datatype::Struct::Utils qw(obj_array_ref2struct);
use Wikidata::Datatype::Value::String;

# Test.
my $snaks_ar = [
	Wikidata::Datatype::Snak->new(
		'datatype' => 'string',
		'datavalue' => Wikidata::Datatype::Value::String->new(
			'value' => 'text',
		),
		'property' => 'P1',
	),
	Wikidata::Datatype::Snak->new(
		'datatype' => 'string',
		'datavalue' => Wikidata::Datatype::Value::String->new(
			'value' => 'foo',
		),
		'property' => 'P2',
	),
];
my $ret_hr = obj_array_ref2struct($snaks_ar, 'foo');
is_deeply(
	$ret_hr,
	{
		'foo' => {
			'P1' => [{
				'datatype' => 'string',
				'datavalue' => {
					'type' => 'string',
					'value' => 'text',
				},
				'property' => 'P1',
				'snaktype' => 'value',
			}],
			'P2' => [{
				'datatype' => 'string',
				'datavalue' => {
					'type' => 'string',
					'value' => 'foo',
				},
				'property' => 'P2',
				'snaktype' => 'value',
			}],
		},
		'foo-order' => [
			'P1',
			'P2',
		],
	},
	'Convert two snaks in array to structure.',
);
