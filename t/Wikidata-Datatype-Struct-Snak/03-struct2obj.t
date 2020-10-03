use strict;
use warnings;

use Test::More 'tests' => 6;
use Test::NoWarnings;
use Wikidata::Datatype::Struct::Snak;

# Test.
my $struct_hr = {
	'datatype' => 'string',
	'datavalue' => {
		'type' => 'string',
		'value' => '1.1',
	},
	'property' => 'P11',
	'snaktype' => 'value',
};
my $ret = Wikidata::Datatype::Struct::Snak::struct2obj($struct_hr);
isa_ok($ret, 'Wikidata::Datatype::Snak');
is($ret->datatype, 'string', 'Method datatype().');
isa_ok($ret->datavalue, 'Wikidata::Datatype::Value::String');
is($ret->property, 'P11', 'Method property().');
is($ret->snaktype, 'value', 'Method snaktype().');
