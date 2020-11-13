use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::More 'tests' => 4;
use Test::NoWarnings;
use Wikidata::Datatype::Value::Globecoordinate;
use Wikidata::Datatype::Struct::Value::Globecoordinate;

# Test.
my $obj = Wikidata::Datatype::Value::Globecoordinate->new(
	'value' => [10.1, 20.1],
);
my $ret_hr = Wikidata::Datatype::Struct::Value::Globecoordinate::obj2struct($obj,
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
	'Output of obj2struct() subroutine.',
);

# Test.
eval {
	Wikidata::Datatype::Struct::Value::Globecoordinate::obj2struct('bad');
};
is($EVAL_ERROR, "Object isn't 'Wikidata::Datatype::Value::Globecoordinate'.\n",
	"Object isn't 'Wikidata::Datatype::Value::Globecoordinate'.");
clean();

# Test.
$obj = Wikidata::Datatype::Value::Globecoordinate->new(
	'altitude' => 100,
	'value' => [10.1, 20.1],
);
$ret_hr = Wikidata::Datatype::Struct::Value::Globecoordinate::obj2struct($obj,
	'http://test.wikidata.org/entity/');
is_deeply(
	$ret_hr,
	{
		'value' => {
			'altitude' => 100,
			'globe' => 'http://test.wikidata.org/entity/Q2',
			'latitude' => 10.1,
			'longitude' => 20.1,
			'precision' => '1e-07',
		},
		'type' => 'globecoordinate',
	},
	'Output of obj2struct() subroutine. With altitude.',
);
