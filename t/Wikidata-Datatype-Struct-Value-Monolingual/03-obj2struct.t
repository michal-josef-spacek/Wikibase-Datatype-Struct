use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::More 'tests' => 3;
use Test::NoWarnings;
use Unicode::UTF8 qw(decode_utf8);
use Wikidata::Datatype::Value::Monolingual;
use Wikidata::Datatype::Struct::Value::Monolingual;

# Test.
my $obj = Wikidata::Datatype::Value::Monolingual->new(
	'language' => 'cs',
	'value' => decode_utf8('Příklad.'),
);
my $ret_hr = Wikidata::Datatype::Struct::Value::Monolingual::obj2struct($obj);
is_deeply(
	$ret_hr,
	{
		'value' => {
			'language' => 'cs',
			'text' => decode_utf8('Příklad.'),
		},
		'type' => 'monolingualtext',
	},
	'Output of obj2struct() subroutine.',
);

# Test.
eval {
	Wikidata::Datatype::Struct::Value::Monolingual::obj2struct('bad');
};
is($EVAL_ERROR, "Object isn't 'Wikidata::Datatype::Value::Monolingual'.\n",
	"Object isn't 'Wikidata::Datatype::Value::Monolingual'.");
clean();
