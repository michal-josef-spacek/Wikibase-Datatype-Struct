use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::More 'tests' => 3;
use Test::NoWarnings;
use Wikidata::Datatype::Value::Item;
use Wikidata::Datatype::Struct::Value::Item;

# Test.
my $obj = Wikidata::Datatype::Value::Item->new(
	'value' => 'Q497',
);
my $ret_hr = Wikidata::Datatype::Struct::Value::Item::obj2struct($obj);
is_deeply(
	$ret_hr,
	{
		'value' => {
			'id' => 'Q497',
			'entity-type' => 'item',
		},
		'type' => 'wikibase-entityid',
	},
	'Output of obj2struct() subroutine.',
);

# Test.
eval {
	Wikidata::Datatype::Struct::Value::Item::obj2struct('bad');
};
is($EVAL_ERROR, "Object isn't 'Wikidata::Datatype::Value::Item'.\n",
	"Object isn't 'Wikidata::Datatype::Value::Item'.");
clean();
