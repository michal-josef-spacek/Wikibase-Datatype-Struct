use strict;
use warnings;

use Test::More 'tests' => 2;
use Test::NoWarnings;
use Wikidata::Datatype::Struct::Sitelink;

# Test.
is($Wikidata::Datatype::Struct::Sitelink::VERSION, 0.01, 'Version.');
