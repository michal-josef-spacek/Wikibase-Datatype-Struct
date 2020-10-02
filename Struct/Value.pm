package Wikidata::Datatype::Struct::Value;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;
use Wikidata::Datatype::Value;
use Wikidata::Datatype::Struct::Value::Item;
use Wikidata::Datatype::Struct::Value::Monolingual;
use Wikidata::Datatype::Struct::Value::String;
use Wikidata::Datatype::Struct::Value::Time;

Readonly::Array our @EXPORT_OK => qw(obj2struct struct2obj);

our $VERSION = 0.01;

sub obj2struct {
	my $obj = shift;

	if (! $obj->isa('Wikidata::Datatype::Value')) {
		err "Object isn't 'Wikidata::Datatype::Value'.";
	}

	my $struct_hr;
	if ($obj->type eq 'item') {
		$struct_hr = Wikidata::Datatype::Struct::Value::Item::obj2struct($obj);
	} elsif ($obj->type eq 'monolingualtext') {
		$struct_hr = Wikidata::Datatype::Struct::Value::Monolingual::obj2struct($obj);
	} elsif ($obj->type eq 'string') {
		$struct_hr = Wikidata::Datatype::Struct::Value::String::obj2struct($obj);
	} elsif ($obj->type eq 'time') {
		$struct_hr = Wikidata::Datatype::Struct::Value::Time::obj2struct($obj);
	} else {
		err "Type '$obj->type' is unsupported.";
	}

	return $struct_hr;
}

sub struct2obj {
	my $struct_hr = shift;

	my $obj;
	if ($struct_hr->{'type'} eq 'wikibase-entityid') {
		$obj = Wikidata::Datatype::Struct::Value::Item::struct2obj($struct_hr);
	} elsif ($struct_hr->{'type'} eq 'monolingualtext') {
		$obj = Wikidata::Datatype::Struct::Value::Monolingual::struct2obj($struct_hr);
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