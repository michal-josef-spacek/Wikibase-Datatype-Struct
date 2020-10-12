use strict;
use warnings;

use Test::More 'tests' => 2;
use Test::NoWarnings;
use Wikidata::Datatype::Struct::Value::Property;

# Test.
is($Wikidata::Datatype::Struct::Value::Property::VERSION, 0.01, 'Version.');
