use strict;
use warnings;

use Test::More 'tests' => 2;
use Test::NoWarnings;
use Wikibase::Datatype::Struct::Reference;

# Test.
is($Wikibase::Datatype::Struct::Reference::VERSION, 0.01, 'Version.');