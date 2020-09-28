use strict;
use warnings;

use Wikidata::Datatype::Struct::Value::Monolingual;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Wikidata::Datatype::Struct::Value::Monolingual::VERSION, 0.01, 'Version.');
