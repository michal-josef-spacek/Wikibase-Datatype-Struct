use strict;
use warnings;

use Test::More 'tests' => 4;
use Test::NoWarnings;
use Wikidata::Datatype::Struct::Value::Item;

# Test.
my $struct_hr = {
	'value' => {
		'numeric-id' => 497,
		'id' => 'Q497',
		'entity-type' => 'item',
	},
	'type' => 'wikibase-entityid',
};
my $ret = Wikidata::Datatype::Struct::Value::Item::struct2obj($struct_hr);
isa_ok($ret, 'Wikidata::Datatype::Value::Item');
is($ret->value, 'Q497', 'Method value().');
is($ret->type, 'item', 'Method type().');
