use strict;
use warnings;

use Test::NoWarnings;
use Test::Pod::Coverage 'tests' => 2;

# Test.
pod_coverage_ok('Wikidata::Datatype::Struct::Statement', 'Wikidata::Datatype::Struct::Statement is covered.');
