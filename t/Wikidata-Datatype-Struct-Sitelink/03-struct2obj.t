use strict;
use warnings;

use Test::More 'tests' => 5;
use Test::NoWarnings;
use Unicode::UTF8 qw(decode_utf8);
use Wikidata::Datatype::Struct::Sitelink;

# Test.
my $struct_hr = {
	'badges' => [],
	'site' => 'cswiki',
	'title' => decode_utf8('Hlavní strana'),
};
my $ret = Wikidata::Datatype::Struct::Sitelink::struct2obj($struct_hr);
isa_ok($ret, 'Wikidata::Datatype::Sitelink');
is_deeply($ret->badges, [], 'Method badges().');
is($ret->site, 'cswiki', 'Method site().');
is($ret->title, decode_utf8('Hlavní strana'), 'Method title().');
