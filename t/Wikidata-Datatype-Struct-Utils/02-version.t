use strict;
use warnings;

use Test::More 'tests' => 2;
use Test::NoWarnings;
use Wikidata::Datatype::Struct::Utils;

# Test.
is($Wikidata::Datatype::Struct::Utils::VERSION, 0.01, 'Version.');
