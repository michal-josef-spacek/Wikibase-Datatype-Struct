use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::More 'tests' => 5;
use Test::NoWarnings;
use Wikidata::Datatype::Value::Quantity;
use Wikidata::Datatype::Struct::Value::Quantity;

# Test.
my $obj = Wikidata::Datatype::Value::Quantity->new(
	'value' => 10,
);
my $ret_hr = Wikidata::Datatype::Struct::Value::Quantity::obj2struct($obj);
is_deeply(
	$ret_hr,
	{
		'value' => {
			'amount' => '+10',
			'unit' => 1,
		},
		'type' => 'quantity',
	},
	'Output of obj2struct() subroutine.',
);

# Test.
$obj = Wikidata::Datatype::Value::Quantity->new(
	'unit' => 'Q123',
	'value' => 10,
);
$ret_hr = Wikidata::Datatype::Struct::Value::Quantity::obj2struct($obj, 'https://test.wikidata.org/entity/');
is_deeply(
	$ret_hr,
	{
		'value' => {
			'amount' => '+10',
			'unit' => 'https://test.wikidata.org/entity/Q123',
		},
		'type' => 'quantity',
	},
	'Output of obj2struct() subroutine.',
);

# Test.
$obj = Wikidata::Datatype::Value::Quantity->new(
	'lower_bound' => 9,
	'unit' => 'Q123',
	'value' => 10,
	'upper_bound' => 11,
);
$ret_hr = Wikidata::Datatype::Struct::Value::Quantity::obj2struct($obj, 'https://test.wikidata.org/entity/');
is_deeply(
	$ret_hr,
	{
		'value' => {
			'amount' => '+10',
			'lowerBound' => '+9',
			'unit' => 'https://test.wikidata.org/entity/Q123',
			'upperBound' => '+11',
		},
		'type' => 'quantity',
	},
	'Output of obj2struct() subroutine.',
);

# Test.
eval {
	Wikidata::Datatype::Struct::Value::Quantity::obj2struct('bad');
};
is($EVAL_ERROR, "Object isn't 'Wikidata::Datatype::Value::Quantity'.\n",
	"Object isn't 'Wikidata::Datatype::Value::Quantity'.");
clean();
