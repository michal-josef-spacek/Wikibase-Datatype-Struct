package Wikidata::Datatype::Struct::Reference;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;
use Wikidata::Datatype::Reference;
use Wikidata::Datatype::Struct::Utils qw(obj_array_ref2struct struct2snaks_array_ref);

Readonly::Array our @EXPORT_OK => qw(obj2struct struct2obj);

our $VERSION = 0.01;

sub obj2struct {
	my ($obj, $base_uri) = @_;

	if (! $obj->isa('Wikidata::Datatype::Reference')) {
		err "Object isn't 'Wikidata::Datatype::Reference'.";
	}

	my $struct_hr = obj_array_ref2struct($obj->snaks, 'snaks', $base_uri);

	return $struct_hr;
}

sub struct2obj {
	my $struct_hr = shift;

	my $obj = Wikidata::Datatype::Reference->new(
		'snaks' => struct2snaks_array_ref($struct_hr, 'snaks'),
	);

	return $obj;
}

1;

__END__
