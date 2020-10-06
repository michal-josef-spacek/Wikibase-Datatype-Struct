use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::More 'tests' => 3;
use Test::NoWarnings;
use Unicode::UTF8 qw(decode_utf8);
use Wikidata::Datatype::Sitelink;
use Wikidata::Datatype::Struct::Sitelink;
use Wikidata::Datatype::Value::Item;

# Test.
my $obj = Wikidata::Datatype::Sitelink->new(
	'badges' => [
		Wikidata::Datatype::Value::Item->new('value' => 'Q1'),
		Wikidata::Datatype::Value::Item->new('value' => 'Q2'),
	],
	'site' => 'cswiki',
	'title' => decode_utf8('Hlavní strana'),
);
my $ret_hr = Wikidata::Datatype::Struct::Sitelink::obj2struct($obj);
is_deeply(
	$ret_hr,
	{
		'badges' => ['Q1', 'Q2'],
		'site' => 'cswiki',
		'title' => decode_utf8('Hlavní strana'),
	},
	'Output of obj2struct() subroutine.',
);

# Test.
eval {
	Wikidata::Datatype::Struct::Sitelink::obj2struct('bad');
};
is($EVAL_ERROR, "Object isn't 'Wikidata::Datatype::Sitelink'.\n",
	"Object isn't 'Wikidata::Datatype::Sitelink'.");
clean();
