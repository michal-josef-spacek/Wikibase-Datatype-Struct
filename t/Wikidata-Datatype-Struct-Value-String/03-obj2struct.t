use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::More 'tests' => 3;
use Test::NoWarnings;
use Wikidata::Datatype::Value::String;
use Wikidata::Datatype::Struct::Value::String;

# Test.
my $obj = Wikidata::Datatype::Value::String->new(
	'value' => 'Text',
);
my $ret_hr = Wikidata::Datatype::Struct::Value::String::obj2struct($obj);
is_deeply(
	$ret_hr,
	{
		'value' => 'Text',
		'type' => 'string',
	},
	'Output of obj2struct() subroutine.',
);

# Test.
eval {
	Wikidata::Datatype::Struct::Value::String::obj2struct('bad');
};
is($EVAL_ERROR, "Object isn't 'Wikidata::Datatype::Value::String'.\n",
	"Object isn't 'Wikidata::Datatype::Value::String'.");
clean();
