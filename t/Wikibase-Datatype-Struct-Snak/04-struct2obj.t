use strict;
use warnings;

use Test::More 'tests' => 6;
use Test::NoWarnings;
use Wikibase::Datatype::Struct::Snak;

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
my $ret = Wikibase::Datatype::Struct::Snak::struct2obj($struct_hr);
isa_ok($ret, 'Wikibase::Datatype::Snak');
is($ret->datatype, 'string', 'Method datatype().');
isa_ok($ret->datavalue, 'Wikibase::Datatype::Value::String');
is($ret->property, 'P11', 'Method property().');
is($ret->snaktype, 'value', 'Method snaktype().');
