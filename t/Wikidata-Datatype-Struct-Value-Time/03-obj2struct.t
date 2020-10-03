use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::More 'tests' => 3;
use Test::NoWarnings;
use Wikidata::Datatype::Value::Time;
use Wikidata::Datatype::Struct::Value::Time;

# Test.
my $obj = Wikidata::Datatype::Value::Time->new(
	'value' => '+2020-09-01T00:00:00Z',
);
my $ret_hr = Wikidata::Datatype::Struct::Value::Time::obj2struct($obj);
is_deeply(
	$ret_hr,
	{
		'value' => {
			'after' => 0,
			'before' => 0,
			'calendarmodel' => 'http://www.wikidata.org/entity/Q1985727',
			'precision' => 11,
			'time' => '+2020-09-01T00:00:00Z',
			'timezone' => 0,
		},
		'type' => 'time',
	},
	'Output of obj2struct() subroutine.',
);

# Test.
eval {
	Wikidata::Datatype::Struct::Value::Time::obj2struct('bad');
};
is($EVAL_ERROR, "Object isn't 'Wikidata::Datatype::Value::Time'.\n",
	"Object isn't 'Wikidata::Datatype::Value::Time'.");
clean();
