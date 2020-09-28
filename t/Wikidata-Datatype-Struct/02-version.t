use strict;
use warnings;

use Test::More 'tests' => 2;
use Test::NoWarnings;
use Wikidata::Datatype::Struct;

# Test.
is($Wikidata::Datatype::Struct::VERSION, 0.01, 'Version.');
