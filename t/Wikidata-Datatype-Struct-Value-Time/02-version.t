use strict;
use warnings;

use Wikidata::Datatype::Struct::Value::Time;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Wikidata::Datatype::Struct::Value::Time::VERSION, 0.01, 'Version.');
