package Wikidata::Datatype::Struct::Value::Item;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;
use Wikidata::Datatype::Value::Item;

Readonly::Array our @EXPORT_OK => qw(obj2struct struct2obj);

our $VERSION = 0.01;

sub obj2struct {
	my $obj = shift;

	if (! $obj->isa('Wikidata::Datatype::Value::Item')) {
		err "Object isn't 'Wikidata::Datatype::Value::Item'.";
	}

	my $struct_hr = {
		'value' => {
			'id' => $obj->value,
			'entity-type' => $obj->type,
		},
		'type' => 'wikibase-entityid',
	};

	return $struct_hr;
}

sub struct2obj {
	my $struct_hr = shift;

	if (! $struct_hr->{'value'}->{'entity-type'}
		|| $struct_hr->{'value'}->{'entity-type'} ne 'item'
		|| $struct_hr->{'type'} ne 'wikibase-entityid') {

		err "Structure isn't for 'item' datatype.";
	}

	my $obj = Wikidata::Datatype::Value::Item->new(
		'value' => $struct_hr->{'value'}->{'id'},
	);

	return $obj;
}

1;

__END__
