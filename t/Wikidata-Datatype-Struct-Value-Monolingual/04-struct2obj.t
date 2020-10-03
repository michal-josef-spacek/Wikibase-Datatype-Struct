use strict;
use warnings;

use Test::More 'tests' => 5;
use Test::NoWarnings;
use Unicode::UTF8 qw(decode_utf8);
use Wikidata::Datatype::Struct::Value::Monolingual;

# Test.
my $struct_hr = {
	'value' => {
		'language' => 'cs',
		'text' => decode_utf8('Příklad.'),
	},
	'type' => 'monolingualtext',
};
my $ret = Wikidata::Datatype::Struct::Value::Monolingual::struct2obj($struct_hr);
isa_ok($ret, 'Wikidata::Datatype::Value::Monolingual');
is($ret->value, decode_utf8('Příklad.'), 'Method value().');
is($ret->language, 'cs', 'Method language().');
is($ret->type, 'monolingualtext', 'Method type().');
