use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::More 'tests' => 4;
use Test::NoWarnings;
use Wikidata::Datatype::Snak;
use Wikidata::Datatype::Statement;
use Wikidata::Datatype::Reference;
use Wikidata::Datatype::Value::String;
use Wikidata::Datatype::Struct::Statement;

# Test.
my $obj = Wikidata::Datatype::Statement->new(
	'entity' => 'Q42',
	'snak' => Wikidata::Datatype::Snak->new(
		'datatype' => 'string',
		'datavalue' => Wikidata::Datatype::Value::String->new(
			'value' => '1.1',
		),
		'property' => 'P11',
	),
	'rank' => 'normal',
);
my $ret_hr = Wikidata::Datatype::Struct::Statement::obj2struct($obj,
	'http://www.wikidata.org/entity/');
is_deeply(
	$ret_hr,
	{
		'mainsnak' => {
			'datatype' => 'string',
			'datavalue' => {
				'type' => 'string',
				'value' => '1.1',
			},
			'property' => 'P11',
			'snaktype' => 'value',
		},
		'rank' => 'normal',
		'type' => 'statement',
	},
	'Output of obj2struct() subroutine.',
);

# Test.
eval {
	Wikidata::Datatype::Struct::Statement::obj2struct('bad');
};
is($EVAL_ERROR, "Object isn't 'Wikidata::Datatype::Statement'.\n",
	"Object isn't 'Wikidata::Datatype::Statement'.");
clean();

# Test.
$obj = Wikidata::Datatype::Statement->new(
	'entity' => 'Q42',
	'property_snaks' => [
		Wikidata::Datatype::Snak->new(
			'datatype' => 'wikibase-item',
			'datavalue' => Wikidata::Datatype::Value::Item->new(
				'value' => 'Q474741',
			),
			'property' => 'P642',
		),
	],
	'snak' => Wikidata::Datatype::Snak->new(
		'datatype' => 'string',
		'datavalue' => Wikidata::Datatype::Value::String->new(
			'value' => '1.1',
		),
		'property' => 'P11',
	),
	'rank' => 'normal',
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
$ret_hr = Wikidata::Datatype::Struct::Statement::obj2struct($obj,
	'http://www.wikidata.org/entity/');
is_deeply(
	$ret_hr,
	{
		'mainsnak' => {
			'datatype' => 'string',
			'datavalue' => {
				'type' => 'string',
				'value' => '1.1',
			},
			'property' => 'P11',
			'snaktype' => 'value',
		},
		'qualifiers-order' => [
			'P642',
		],
		'qualifiers' => {
			'P642' => [
				{
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
				},
			],
		},
		'rank' => 'normal',
		'references' => [
			{
				'snaks' => {
					'P248' => [{
						'datatype' => 'wikibase-item',
						'datavalue' => {
							'value' => {
								'entity-type' => 'item',
								'id' => 'Q53919',
								'numeric-id' => 53919,
							},
							'type' => 'wikibase-entityid'
						},
						'property' => 'P248',
						'snaktype' => 'value',
					}],
					'P214' => [{
						'datatype' => 'external-id',
						'datavalue' => {
							'value' => '113230702',
							'type' => 'string',
						},
						'property' => 'P214',
						'snaktype' => 'value',
					}],
					'P813' => [{
						'datatype' => 'time',
						'datavalue' => {
							'value' => {
								'after' => 0,
								'before' => 0,
								'calendarmodel' => 'http://www.wikidata.org/entity/Q1985727',
								'precision' => 11,
								'time' => '+2013-12-07T00:00:00Z',
								'timezone' => 0,
							},
							'type' => 'time',
						},
						'property' => 'P813',
						'snaktype' => 'value',
					}],
				},
				'snaks-order' => [
					'P248',
					'P214',
					'P813'
				],
			},
		],
		'type' => 'statement',
	},
	'Output of obj2struct() subroutine - with property snak and references.',
);
