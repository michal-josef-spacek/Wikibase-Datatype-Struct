use strict;
use warnings;

use Test::NoWarnings;
use Test::Pod::Coverage 'tests' => 2;

# Test.
pod_coverage_ok('Wikidata::Datatype::Struct::Snak', 'Wikidata::Datatype::Struct::Snak is covered.');
