use strict;
use warnings;

use Test::More 'tests' => 2;
use Test::NoWarnings;
use Wikibase::Datatype::Struct::Sitelink;

# Test.
is($Wikibase::Datatype::Struct::Sitelink::VERSION, 0.15, 'Version.');
