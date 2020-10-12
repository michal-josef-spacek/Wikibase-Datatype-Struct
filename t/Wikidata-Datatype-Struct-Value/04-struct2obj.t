use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::More 'tests' => 31;
use Test::NoWarnings;
use Unicode::UTF8 qw(decode_utf8);
use Wikidata::Datatype::Struct::Value;

# Test.
my $struct_hr = {
	'value' => {
		'altitude' => 'null',
		'globe' => 'http://test.wikidata.org/entity/Q111',
		'latitude' => 10.1,
		'longitude' => 20.1,
		'precision' => 1,
	},
	'type' => 'globecoordinate',
};
my $ret = Wikidata::Datatype::Struct::Value::struct2obj($struct_hr);
isa_ok($ret, 'Wikidata::Datatype::Value::Globecoordinate');
is($ret->altitude, undef, 'Globecoordinate: Method altitude().');
is($ret->latitude, 10.1, 'Globecoordinate: Method latitude().');
is($ret->longitude, 20.1, 'Globecoordinate: Method longitude().');
is($ret->precision, 1, 'Globecoordinate: Method precision().');
is($ret->type, 'globecoordinate', 'Globecoordinate: Method type().');
is_deeply($ret->value, [10.1, 20.1], 'Globecoordinate: Method value().');

# Test.
$struct_hr = {
	'value' => {
		'numeric-id' => 497,
		'id' => 'Q497',
		'entity-type' => 'item',
	},
	'type' => 'wikibase-entityid',
};
$ret = Wikidata::Datatype::Struct::Value::struct2obj($struct_hr);
isa_ok($ret, 'Wikidata::Datatype::Value::Item');
is($ret->value, 'Q497', 'Item: Method value().');
is($ret->type, 'item', 'Item: Method type().');

# Test.
$struct_hr = {
	'value' => {
		'language' => 'cs',
		'text' => decode_utf8('Příklad.'),
	},
	'type' => 'monolingualtext',
};
$ret = Wikidata::Datatype::Struct::Value::struct2obj($struct_hr);
isa_ok($ret, 'Wikidata::Datatype::Value::Monolingual');
is($ret->value, decode_utf8('Příklad.'), 'Monolingual: Method value().');
is($ret->language, 'cs', 'Monolingual: Method language().');
is($ret->type, 'monolingualtext', 'Monolingual: Method type().');

# Test.
$struct_hr = {
	'value' => {
		'amount' => '+10',
		'unit' => 'https://test.wikidata.org/entity/Q123',
	},
	'type' => 'quantity',
};
$ret = Wikidata::Datatype::Struct::Value::struct2obj($struct_hr);
isa_ok($ret, 'Wikidata::Datatype::Value::Quantity');
is($ret->value, 10, 'Quantity: Method value().');
is($ret->unit, 'Q123', 'Quantity: Method unit().');
is($ret->type, 'quantity', 'Quantity: Method type().');

# Test.
$struct_hr = {
	'value' => 'Text',
	'type' => 'string',
};
$ret = Wikidata::Datatype::Struct::Value::struct2obj($struct_hr);
isa_ok($ret, 'Wikidata::Datatype::Value::String');
is($ret->value, 'Text', 'String: Method value().');
is($ret->type, 'string', 'String: Method type().');

# Test.
$struct_hr = {
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
$ret = Wikidata::Datatype::Struct::Value::struct2obj($struct_hr);
isa_ok($ret, 'Wikidata::Datatype::Value::Time');
is($ret->after, 0, 'Time: Method after().');
is($ret->before, 0, 'Time: Method before().');
is($ret->calendarmodel, 'Q1985727', 'Time: Method calendarmodel().');
is($ret->precision, 11, 'Time: Method precision().');
is($ret->timezone, 0, 'Time: Method timezone().');
is($ret->type, 'time', 'Time: Method type().');
is($ret->value, '+2020-09-01T00:00:00Z', 'Time: Method value().');

# Test.
$struct_hr = {
	'value' => {},
	'type' => 'bad',
};
eval {
	Wikidata::Datatype::Struct::Value::struct2obj($struct_hr);
};
is($EVAL_ERROR, "Type 'bad' is unsupported.\n", "Type 'bad' is unsupported.");
clean();
