package Wikidata::Datatype::Struct::Statement;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;
use Wikidata::Datatype::Statement;
use Wikidata::Datatype::Struct::Reference;
use Wikidata::Datatype::Struct::Snak;
use Wikidata::Datatype::Struct::Utils qw(obj_array_ref2struct struct2snaks_array_ref);

Readonly::Array our @EXPORT_OK => qw(obj2struct struct2obj);

our $VERSION = 0.01;

sub obj2struct {
	my $obj = shift;

	if (! $obj->isa('Wikidata::Datatype::Statement')) {
		err "Object isn't 'Wikidata::Datatype::Statement'.";
	}

	my $struct_hr = {
		'mainsnak' => Wikidata::Datatype::Struct::Snak::obj2struct($obj->snak),
		@{$obj->property_snaks} ? (
			%{obj_array_ref2struct($obj->property_snaks, 'qualifiers')},
		) : (),
		'rank' => $obj->rank,
		@{$obj->references} ? (
			'references' => [
				map { Wikidata::Datatype::Struct::Reference::obj2struct($_); }
				@{$obj->references},
			],
		) : (),
		'type' => 'statement',
	};

	return $struct_hr;
}

sub struct2obj {
	my ($struct_hr, $entity) = @_;

	my $obj = Wikidata::Datatype::Statement->new(
		'entity' => $entity,
		'property_snaks' => struct2snaks_array_ref($struct_hr, 'qualifiers'),
		'snak' => Wikidata::Datatype::Struct::Snak::struct2obj($struct_hr->{'mainsnak'}),
		'references' => [
			map { Wikidata::Datatype::Struct::Reference::struct2obj($_) }
			@{$struct_hr->{'references'}}
		],
		'rank' => $struct_hr->{'rank'},
	);

	return $obj;
}

1;

__END__
