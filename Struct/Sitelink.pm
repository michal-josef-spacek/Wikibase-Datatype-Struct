package Wikidata::Datatype::Struct::Sitelink;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;
use Wikidata::Datatype::Sitelink;

Readonly::Array our @EXPORT_OK => qw(obj2struct struct2obj);

our $VERSION = 0.01;

sub obj2struct {
	my $obj = shift;

	if (! $obj->isa('Wikidata::Datatype::Sitelink')) {
		err "Object isn't 'Wikidata::Datatype::Sitelink'.";
	}

	my $struct_hr = {
		'badges' => $obj->badges,
		'site' => $obj->site,
		'title' => $obj->title,
	};

	return $struct_hr;
}

sub struct2obj {
	my ($struct_hr, $entity) = @_;

	my $obj = Wikidata::Datatype::Sitelink->new(
		'badges' => $struct_hr->{'badges'},
		'site' => $struct_hr->{'site'},
		'title' => $struct_hr->{'title'},
	);

	return $obj;
}

1;

__END__
