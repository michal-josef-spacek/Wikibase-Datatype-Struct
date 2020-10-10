use strict;
use warnings;

use Test::More 'tests' => 2;
use Test::NoWarnings;
use Wikidata::Datatype::Struct::Value::Quantity;

# Test.
is($Wikidata::Datatype::Struct::Value::Quantity::VERSION, 0.01, 'Version.');
