use strict;
use warnings;

use Test::More 'tests' => 2;
use Test::NoWarnings;
use Wikidata::Datatype::Struct::Reference;

# Test.
is($Wikidata::Datatype::Struct::Reference::VERSION, 0.01, 'Version.');
