use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::More 'tests' => 3;
use Test::NoWarnings;
use Wikibase::Datatype::Snak;
use Wikibase::Datatype::Value::String;
use Wikibase::Datatype::Struct::Snak;

# Test.
my $obj = Wikibase::Datatype::Snak->new(
	'datatype' => 'string',
	'datavalue' => Wikibase::Datatype::Value::String->new(
		'value' => '1.1',
	),
	'property' => 'P11',
);
my $ret_hr = Wikibase::Datatype::Struct::Snak::obj2struct($obj);
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
	Wikibase::Datatype::Struct::Snak::obj2struct('bad');
};
is($EVAL_ERROR, "Object isn't 'Wikibase::Datatype::Snak'.\n",
	"Object isn't 'Wikibase::Datatype::Snak'.");
clean();
