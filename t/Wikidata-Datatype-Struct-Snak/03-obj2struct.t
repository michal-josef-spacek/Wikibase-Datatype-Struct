use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::More 'tests' => 3;
use Test::NoWarnings;
use Wikidata::Datatype::Snak;
use Wikidata::Datatype::Value::String;
use Wikidata::Datatype::Struct::Snak;

# Test.
my $obj = Wikidata::Datatype::Snak->new(
	'datatype' => 'string',
	'datavalue' => Wikidata::Datatype::Value::String->new(
		'value' => '1.1',
	),
	'property' => 'P11',
);
my $ret_hr = Wikidata::Datatype::Struct::Snak::obj2struct($obj);
is_deeply(
	$ret_hr,
	{
		'datatype' => 'string',
		'datavalue' => {
			'type' => 'string',
			'value' => '1.1',
		},
		'property' => 'P11',
		'snaktype' => 'value',
	},
	'Output of obj2struct() subroutine.',
);

# Test.
eval {
	Wikidata::Datatype::Struct::Snak::obj2struct('bad');
};
is($EVAL_ERROR, "Object isn't 'Wikidata::Datatype::Snak'.\n",
	"Object isn't 'Wikidata::Datatype::Snak'.");
clean();
