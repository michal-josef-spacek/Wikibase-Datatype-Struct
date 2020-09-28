use strict;
use warnings;

use Test::More 'tests' => 9;
use Test::NoWarnings;
use Wikidata::Datatype::Struct::Value::Time;

# Test.
my $struct_hr = {
	'value' => {
		'after' => 0,
		'before' => 0,
		'calendarmodel' => 'http://www.wikidata.org/entity/Q1985727',
		'precision' => 11,
		'time' => '+2020-09-01T00:00:00Z',
		'timezone' => 0,
	},
	'type' => 'time',
};
my $ret = Wikidata::Datatype::Struct::Value::Time::struct2obj($struct_hr);
isa_ok($ret, 'Wikidata::Datatype::Value::Time');
is($ret->after, 0, 'Method after().');
is($ret->before, 0, 'Method before().');
is($ret->calendarmodel, 'http://www.wikidata.org/entity/Q1985727',
	'Method calendarmodel().');
is($ret->precision, 11, 'Method precision().');
is($ret->timezone, 0, 'Method timezone().');
is($ret->type, 'time', 'Method type().');
is($ret->value, '+2020-09-01T00:00:00Z', 'Method value().');
