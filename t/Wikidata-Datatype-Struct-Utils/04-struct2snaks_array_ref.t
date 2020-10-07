use strict;
use warnings;

use Test::More 'tests' => 7;
use Test::NoWarnings;
use Wikidata::Datatype::Struct::Utils qw(struct2snaks_array_ref);

# Test.
my $struct_hr = {
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
};
my $snaks_ar = struct2snaks_array_ref($struct_hr, 'foo');
is($snaks_ar->[0]->datatype, 'string', 'Get #1 datatype value.');
is($snaks_ar->[0]->datavalue->value, 'text', 'Get #1 data value.');
is($snaks_ar->[0]->property, 'P1', 'Get #1 property value.');
is($snaks_ar->[1]->datatype, 'string', 'Get #2 datatype value.');
is($snaks_ar->[1]->datavalue->value, 'foo', 'Get #2 data value.');
is($snaks_ar->[1]->property, 'P2', 'Get #2 property value.');