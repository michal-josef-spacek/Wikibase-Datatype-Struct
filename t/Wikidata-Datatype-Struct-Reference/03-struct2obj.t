use strict;
use warnings;

use Test::More 'tests' => 5;
use Test::NoWarnings;
use Wikidata::Datatype::Struct::Reference;

# Test.
my $struct_hr = {
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
};
my $ret = Wikidata::Datatype::Struct::Reference::struct2obj($struct_hr);
isa_ok($ret, 'Wikidata::Datatype::Reference');
is($ret->snaks->[0]->property, 'P93', 'Get property.');
is($ret->snaks->[0]->datatype, 'url', 'Get datatype.');
is($ret->snaks->[0]->datavalue->value, 'https://skim.cz', 'Get value.');
