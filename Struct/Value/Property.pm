package Wikidata::Datatype::Struct::Value::Property;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;
use Wikidata::Datatype::Value::Property;

Readonly::Array our @EXPORT_OK => qw(obj2struct struct2obj);

our $VERSION = 0.01;

sub obj2struct {
	my $obj = shift;

	if (! $obj->isa('Wikidata::Datatype::Value::Property')) {
		err "Object isn't 'Wikidata::Datatype::Value::Property'.";
	}

	my $numeric_id = $obj->value;
	$numeric_id =~ s/^P//ms;
	my $struct_hr = {
		'value' => {
			'numeric-id' => $numeric_id,
			'entity-type' => 'property',
			'id' => $obj->value,
		},
		'type' => 'wikibase-entityid',
	};

	return $struct_hr;
}

sub struct2obj {
	my $struct_hr = shift;

	if ($struct_hr->{'type'} ne 'wikibase-entityid') {
		err "Structure isn't for 'wikibase-entityid' datatype.";
	}

	my $obj = Wikidata::Datatype::Value::Property->new(
		'value' => $struct_hr->{'value'}->{'id'},
	);

	return $obj;
}

1;

__END__
