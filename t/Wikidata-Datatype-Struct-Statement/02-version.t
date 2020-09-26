use strict;
use warnings;

use Wikidata::Datatype::Struct::Statement;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Wikidata::Datatype::Struct::Statement::VERSION, 0.01, 'Version.');
