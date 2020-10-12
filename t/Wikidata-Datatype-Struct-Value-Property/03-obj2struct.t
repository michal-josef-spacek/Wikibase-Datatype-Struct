use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::More 'tests' => 3;
use Test::NoWarnings;
use Wikidata::Datatype::Value::Property;
use Wikidata::Datatype::Struct::Value::Property;

# Test.
my $obj = Wikidata::Datatype::Value::Property->new(
	'value' => 'P111',
);
my $ret_hr = Wikidata::Datatype::Struct::Value::Property::obj2struct($obj);
is_deeply(
	$ret_hr,
	{
		'value' => {
			'id' => 'P111',
			'entity-type' => 'property',
			'numeric-id' => 111,
		},
		'type' => 'wikibase-entityid',
	},
	'Output of obj2struct() subroutine.',
);

# Test.
eval {
	Wikidata::Datatype::Struct::Value::Property::obj2struct('bad');
};
is($EVAL_ERROR, "Object isn't 'Wikidata::Datatype::Value::Property'.\n",
	"Object isn't 'Wikidata::Datatype::Value::Property'.");
clean();
