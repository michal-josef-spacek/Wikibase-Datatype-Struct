package Wikidata::Datatype::Struct::Value::String;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;
use Wikidata::Datatype::Value::String;

Readonly::Array our @EXPORT_OK => qw(obj2struct struct2obj);

our $VERSION = 0.01;

sub obj2struct {
	my $obj = shift;

	if (! $obj->isa('Wikidata::Datatype::Value::String')) {
		err "Object isn't 'Wikidata::Datatype::Value::String'.";
	}

	my $struct_hr = {
		'value' => $obj->value,
		'type' => 'string',
	};

	return $struct_hr;
}

sub struct2obj {
	my $struct_hr = shift;

	if ($struct_hr->{'type'} ne 'string') {
		err "Structure isn't for 'string' datatype.";
	}

	my $obj = Wikidata::Datatype::Value::String->new(
		'value' => $struct_hr->{'value'},
	);

	return $obj;
}

1;

__END__
