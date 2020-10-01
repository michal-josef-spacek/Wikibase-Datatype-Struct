package Wikidata::Datatype::Struct::Statement;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;
use Wikidata::Datatype::Statement;
use Wikidata::Datatype::Struct::Snak;

Readonly::Array our @EXPORT_OK => qw(obj2struct struct2obj);

our $VERSION = 0.01;

sub obj2struct {
	my $obj = shift;

	if (! $obj->isa('Wikidata::Datatype::Statement')) {
		err "Object isn't 'Wikidata::Datatype::Statement'.";
	}

	my $struct_hr = {
		'mainsnak' => Wikidata::Datatype::Struct::Snak::obj2struct($obj->snak),
		'rank' => $obj->rank,
		'type' => 'statement',
		# TODO
		# property_snak
		# references
	};

	return $struct_hr;
}

sub struct2obj {
	my ($struct_hr, $entity) = @_;

	my $obj = Wikidata::Datatype::Statement->new(
		'entity' => $entity,
		'snak' => Wikidata::Datatype::Struct::Snak::struct2obj($struct_hr->{'mainsnak'}),
		'rank' => $struct_hr->{'rank'},
		# TODO
		# property_snak
		# references
	);

	return $obj;
}

1;

__END__
