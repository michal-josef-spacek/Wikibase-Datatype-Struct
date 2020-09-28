use strict;
use warnings;

use Test::More 'tests' => 2;
use Test::NoWarnings;
use Wikidata::Datatype::Struct::Value::Monolingual;

# Test.
is($Wikidata::Datatype::Struct::Value::Monolingual::VERSION, 0.01, 'Version.');
