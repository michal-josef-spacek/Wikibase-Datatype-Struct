use strict;
use warnings;

use Test::More 'tests' => 4;
use Test::NoWarnings;
use Wikidata::Datatype::Struct::Value::String;

# Test.
my $struct = {
	'value' => 'Text',
	'type' => 'string',
};
my $ret = Wikidata::Datatype::Struct::Value::String::struct2obj($struct);
isa_ok($ret, 'Wikidata::Datatype::Value::String');
is($ret->value, 'Text', 'Method value().');
is($ret->type, 'string', 'Method type().');
