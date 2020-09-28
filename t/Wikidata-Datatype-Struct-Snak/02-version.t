use strict;
use warnings;

use Wikidata::Datatype::Struct::Snak;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Wikidata::Datatype::Struct::Snak::VERSION, 0.01, 'Version.');
