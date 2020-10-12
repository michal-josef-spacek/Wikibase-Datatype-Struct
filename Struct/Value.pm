package Wikidata::Datatype::Struct::Value;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;
use Wikidata::Datatype::Value;
use Wikidata::Datatype::Struct::Value::Globecoordinate;
use Wikidata::Datatype::Struct::Value::Item;
use Wikidata::Datatype::Struct::Value::Monolingual;
use Wikidata::Datatype::Struct::Value::Property;
use Wikidata::Datatype::Struct::Value::Quantity;
use Wikidata::Datatype::Struct::Value::String;
use Wikidata::Datatype::Struct::Value::Time;

Readonly::Array our @EXPORT_OK => qw(obj2struct struct2obj);

our $VERSION = 0.01;

sub obj2struct {
	my ($obj, $base_uri) = @_;

	if (! $obj->isa('Wikidata::Datatype::Value')) {
		err "Object isn't 'Wikidata::Datatype::Value'.";
	}

	my $struct_hr;
	my $type = $obj->type;
	if ($type eq 'globecoordinate') {
		$struct_hr = Wikidata::Datatype::Struct::Value::Globecoordinate::obj2struct($obj, $base_uri);
	} elsif ($type eq 'item') {
		$struct_hr = Wikidata::Datatype::Struct::Value::Item::obj2struct($obj);
	} elsif ($type eq 'monolingualtext') {
		$struct_hr = Wikidata::Datatype::Struct::Value::Monolingual::obj2struct($obj);
	} elsif ($type eq 'property') {
		$struct_hr = Wikidata::Datatype::Struct::Value::Property::obj2struct($obj);
	} elsif ($type eq 'quantity') {
		$struct_hr = Wikidata::Datatype::Struct::Value::Quantity::obj2struct($obj, $base_uri);
	} elsif ($type eq 'string') {
		$struct_hr = Wikidata::Datatype::Struct::Value::String::obj2struct($obj);
	} elsif ($type eq 'time') {
		$struct_hr = Wikidata::Datatype::Struct::Value::Time::obj2struct($obj, $base_uri);
	} else {
		err "Type '$type' is unsupported.";
	}

	return $struct_hr;
}

sub struct2obj {
	my $struct_hr = shift;

	my $obj;
	if ($struct_hr->{'type'} eq 'wikibase-entityid') {
		if ($struct_hr->{'value'}->{'entity-type'} eq 'item') {
			$obj = Wikidata::Datatype::Struct::Value::Item::struct2obj($struct_hr);
		} else {
			$obj = Wikidata::Datatype::Struct::Value::Property::struct2obj($struct_hr);
		}
	} elsif ($struct_hr->{'type'} eq 'globecoordinate') {
		$obj = Wikidata::Datatype::Struct::Value::Globecoordinate::struct2obj($struct_hr);
	} elsif ($struct_hr->{'type'} eq 'monolingualtext') {
		$obj = Wikidata::Datatype::Struct::Value::Monolingual::struct2obj($struct_hr);
	} elsif ($struct_hr->{'type'} eq 'quantity') {
		$obj = Wikidata::Datatype::Struct::Value::Quantity::struct2obj($struct_hr);
	} elsif ($struct_hr->{'type'} eq 'string') {
		$obj = Wikidata::Datatype::Struct::Value::String::struct2obj($struct_hr);
	} elsif ($struct_hr->{'type'} eq 'time') {
		$obj = Wikidata::Datatype::Struct::Value::Time::struct2obj($struct_hr);
	} else {
		err "Type '$struct_hr->{'type'}' is unsupported.";
	}

	return $obj;
}

1;

__END__
