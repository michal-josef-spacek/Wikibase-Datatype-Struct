use strict;
use warnings;

use Test::More 'tests' => 9;
use Test::NoWarnings;
use Wikidata::Datatype::Struct::Value::Globecoordinate;

# Test.
my $struct_hr = {
	'value' => {
		'altitude' => 'null',
		'globe' => 'http://test.wikidata.org/entity/Q111',
		'latitude' => 10.1,
		'longitude' => 20.1,
		'precision' => 1,
	},
	'type' => 'globecoordinate',
};
my $ret = Wikidata::Datatype::Struct::Value::Globecoordinate::struct2obj($struct_hr);
isa_ok($ret, 'Wikidata::Datatype::Value::Globecoordinate');
is($ret->altitude, undef, 'Method altitude().');
is($ret->globe, 'Q111', 'Method globe().');
is($ret->latitude, 10.1, 'Method latitude().');
is($ret->longitude, 20.1, 'Method longitude().');
is($ret->precision, 1, 'Method precision().');
is($ret->type, 'globecoordinate', 'Method type().');
is_deeply($ret->value, [10.1, 20.1], 'Method value().');
