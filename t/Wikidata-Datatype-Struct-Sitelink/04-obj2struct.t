use strict;
use warnings;

use Test::More 'tests' => 2;
use Test::NoWarnings;
use Unicode::UTF8 qw(decode_utf8);
use Wikidata::Datatype::Sitelink;
use Wikidata::Datatype::Struct::Sitelink;

# Test.
my $obj = Wikidata::Datatype::Sitelink->new(
	'site' => 'cswiki',
	'title' => decode_utf8('Hlavní strana'),
);
my $ret_hr = Wikidata::Datatype::Struct::Sitelink::obj2struct($obj);
is_deeply(
	$ret_hr,
	{
		'badges' => [],
		'site' => 'cswiki',
		'title' => decode_utf8('Hlavní strana'),
	},
	'Output of obj2struct() subroutine.',
);
