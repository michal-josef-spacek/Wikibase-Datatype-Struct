use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::More 'tests' => 3;
use Test::NoWarnings;
use Wikidata::Datatype::Snak;
use Wikidata::Datatype::Statement;
use Wikidata::Datatype::Value::String;
use Wikidata::Datatype::Struct::Statement;

# Test.
my $obj = Wikidata::Datatype::Statement->new(
	'entity' => 'Q42',
	'snak' => Wikidata::Datatype::Snak->new(
		'datatype' => 'string',
		'datavalue' => Wikidata::Datatype::Value::String->new(
			'value' => '1.1',
		),
		'property' => 'P11',
	),
	'rank' => 'normal',
);
my $ret_hr = Wikidata::Datatype::Struct::Statement::obj2struct($obj);
is_deeply(
	$ret_hr,
	{
		'mainsnak' => {
			'datatype' => 'string',
			'datavalue' => {
				'type' => 'string',
				'value' => '1.1',
			},
			'property' => 'P11',
			'snaktype' => 'value',
		},
		'rank' => 'normal',
		'type' => 'statement',
	},
	'Output of obj2struct() subroutine.',
);

# Test.
eval {
	Wikidata::Datatype::Struct::Statement::obj2struct('bad');
};
is($EVAL_ERROR, "Object isn't 'Wikidata::Datatype::Statement'.\n",
	"Object isn't 'Wikidata::Datatype::Statement'.");
clean();
