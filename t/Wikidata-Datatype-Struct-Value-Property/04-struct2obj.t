use strict;
use warnings;

use Test::More 'tests' => 4;
use Test::NoWarnings;
use Wikidata::Datatype::Struct::Value::Property;

# Test.
my $struct_hr = {
	'value' => {
		'numeric-id' => 111,
		'id' => 'P111',
		'entity-type' => 'property',
	},
	'type' => 'wikibase-entityid',
};
my $ret = Wikidata::Datatype::Struct::Value::Property::struct2obj($struct_hr);
isa_ok($ret, 'Wikidata::Datatype::Value::Property');
is($ret->value, 'P111', 'Method value().');
is($ret->type, 'property', 'Method type().');
