use strict;
use warnings;

use Test::More 'tests' => 2;
use Test::NoWarnings;
use Wikidata::Datatype::Struct::Statement;

# Test.
is($Wikidata::Datatype::Struct::Statement::VERSION, 0.01, 'Version.');
