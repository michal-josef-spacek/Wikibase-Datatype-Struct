use strict;
use warnings;

use Test::More 'tests' => 2;
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
