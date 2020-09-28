use strict;
use warnings;

use Test::More 'tests' => 2;
use Test::NoWarnings;
use Wikidata::Datatype::Struct::Snak;

# Test.
is($Wikidata::Datatype::Struct::Snak::VERSION, 0.01, 'Version.');
