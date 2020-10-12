use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::More 'tests' => 10;
use Test::NoWarnings;
use Unicode::UTF8 qw(decode_utf8);
use Wikidata::Datatype::Value::Globecoordinate;
use Wikidata::Datatype::Value::Item;
use Wikidata::Datatype::Value::Monolingual;
use Wikidata::Datatype::Value::Property;
use Wikidata::Datatype::Value::Quantity;
use Wikidata::Datatype::Value::String;
use Wikidata::Datatype::Value::Time;
use Wikidata::Datatype::Struct::Value;

# Test.
my $obj = Wikidata::Datatype::Value::Globecoordinate->new(
	'value' => [10.1, 20.1],
);
my $ret_hr = Wikidata::Datatype::Struct::Value::obj2struct($obj,
	'http://test.wikidata.org/entity/');
is_deeply(
	$ret_hr,
	{
		'value' => {
			'altitude' => 'null',
			'globe' => 'http://test.wikidata.org/entity/Q2',
			'latitude' => 10.1,
			'longitude' => 20.1,
			'precision' => '1e-07',
		},
		'type' => 'globecoordinate',
	},
	'Item: Output of obj2struct() subroutine.',
);

# Test.
$obj = Wikidata::Datatype::Value::Item->new(
	'value' => 'Q497',
);
$ret_hr = Wikidata::Datatype::Struct::Value::obj2struct($obj);
is_deeply(
	$ret_hr,
	{
		'value' => {
			'entity-type' => 'item',
			'id' => 'Q497',
			'numeric-id' => 497,
		},
		'type' => 'wikibase-entityid',
	},
	'Item: Output of obj2struct() subroutine.',
);

# Test.
$obj = Wikidata::Datatype::Value::Monolingual->new(
	'language' => 'cs',
	'value' => decode_utf8('Příklad.'),
);
$ret_hr = Wikidata::Datatype::Struct::Value::obj2struct($obj);
is_deeply(
	$ret_hr,
	{
		'value' => {
			'language' => 'cs',
			'text' => decode_utf8('Příklad.'),
		},
		'type' => 'monolingualtext',
	},
	'Monolingual: Output of obj2struct() subroutine.',
);

# Test.
$obj = Wikidata::Datatype::Value::Property->new(
	'value' => 'P123',
);
$ret_hr = Wikidata::Datatype::Struct::Value::obj2struct($obj, 'https://test.wikidata.org/entity/');
is_deeply(
	$ret_hr,
	{
		'value' => {
			'entity-type' => 'property',
			'id' => 'P123',
			'numeric-id' => 123,
		},
		'type' => 'wikibase-entityid',
	},
	'Quantity: Output of obj2struct() subroutine.',
);

# Test.
$obj = Wikidata::Datatype::Value::Quantity->new(
	'unit' => 'Q123',
	'value' => 10,
);
$ret_hr = Wikidata::Datatype::Struct::Value::obj2struct($obj, 'https://test.wikidata.org/entity/');
is_deeply(
	$ret_hr,
	{
		'value' => {
			'amount' => '+10',
			'unit' => 'https://test.wikidata.org/entity/Q123',
		},
		'type' => 'quantity',
	},
	'Quantity: Output of obj2struct() subroutine.',
);

# Test.
$obj = Wikidata::Datatype::Value::String->new(
	'value' => 'Text',
);
$ret_hr = Wikidata::Datatype::Struct::Value::obj2struct($obj);
is_deeply(
	$ret_hr,
	{
		'value' => 'Text',
		'type' => 'string',
	},
	'String: Output of obj2struct() subroutine.',
);

# Test.
$obj = Wikidata::Datatype::Value::Time->new(
	'value' => '+2020-09-01T00:00:00Z',
);
$ret_hr = Wikidata::Datatype::Struct::Value::obj2struct($obj, 'https://www.wikidata.org/entity/');
is_deeply(
	$ret_hr,
	{
		'value' => {
			'after' => 0,
			'before' => 0,
			'calendarmodel' => 'https://www.wikidata.org/entity/Q1985727',
			'precision' => 11,
			'time' => '+2020-09-01T00:00:00Z',
			'timezone' => 0,
		},
		'type' => 'time',
	},
	'Time: Output of obj2struct() subroutine.',
);

# Test.
$obj = Wikidata::Datatype::Value->new(
	'value' => 'text',
	'type' => 'bad',
);
eval {
	Wikidata::Datatype::Struct::Value::obj2struct($obj);
};
is($EVAL_ERROR, "Type 'bad' is unsupported.\n",
	"Type 'bad' is unsupported.");
clean();

# Test.
eval {
	Wikidata::Datatype::Struct::Value::obj2struct('bad');
};
is($EVAL_ERROR, "Object isn't 'Wikidata::Datatype::Value'.\n",
	"Object isn't 'Wikidata::Datatype::Value'.");
clean();
