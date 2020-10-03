use strict;
use warnings;

use Test::More 'tests' => 5;
use Test::NoWarnings;
use Wikidata::Datatype::Struct::Statement;

# Test.
my $struct_hr = {
	'mainsnak' => {
		'datatype' => 'string',
		'datavalue' => {
			'type' => 'string',
			'value' => '1.1',
		},
		'property' => 'P11',
		'snaktype' => 'value',
	},
	'type' => 'statement',
	'rank' => 'normal',
};
my $ret = Wikidata::Datatype::Struct::Statement::struct2obj($struct_hr, 'Q42');
isa_ok($ret, 'Wikidata::Datatype::Statement');
is($ret->entity, 'Q42', 'Method entity().');
isa_ok($ret->snak, 'Wikidata::Datatype::Snak');
is($ret->rank, 'normal', 'Method rank().');
