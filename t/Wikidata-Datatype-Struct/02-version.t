use strict;
use warnings;

use Wikidata::Datatype::Struct;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Wikidata::Datatype::Struct::VERSION, 0.01, 'Version.');
