package Wikidata::Datatype::Struct::Snak;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;
use Wikidata::Datatype::Snak;
use Wikidata::Datatype::Struct::Value;

Readonly::Array our @EXPORT_OK => qw(obj2struct struct2obj);

our $VERSION = 0.01;

sub obj2struct {
	my ($obj, $base_uri) = @_;

	if (! $obj->isa('Wikidata::Datatype::Snak')) {
		err "Object isn't 'Wikidata::Datatype::Snak'.";
	}

	my $struct_hr = {
		'datavalue' => Wikidata::Datatype::Struct::Value::obj2struct($obj->datavalue, $base_uri),
		'datatype' => $obj->datatype,
		'property' => $obj->property,
		'snaktype' => $obj->snaktype,
	};

	return $struct_hr;
}

sub struct2obj {
	my $struct_hr = shift;

	my $obj = Wikidata::Datatype::Snak->new(
		'datavalue' => Wikidata::Datatype::Struct::Value::struct2obj($struct_hr->{'datavalue'}),
		'datatype' => $struct_hr->{'datatype'},
		'property' => $struct_hr->{'property'},
		'snaktype' => $struct_hr->{'snaktype'},
	);

	return $obj;
}

1;

__END__
