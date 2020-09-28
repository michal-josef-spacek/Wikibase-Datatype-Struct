use strict;
use warnings;

use Wikidata::Datatype::Struct::Value;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Wikidata::Datatype::Struct::Value::VERSION, 0.01, 'Version.');
