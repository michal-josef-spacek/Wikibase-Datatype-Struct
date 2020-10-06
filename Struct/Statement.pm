package Wikidata::Datatype::Struct::Statement;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;
use Wikidata::Datatype::Statement;
use Wikidata::Datatype::Struct::Reference;
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
		@{$obj->property_snaks} ? (
			%{_obj_array_ref2struct($obj->property_snaks)},
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
		'property_snaks' => _struct2qualifiers_array_ref($struct_hr),
		'snak' => Wikidata::Datatype::Struct::Snak::struct2obj($struct_hr->{'mainsnak'}),
		'references' => [
			map { Wikidata::Datatype::Struct::Reference::struct2obj($_) }
			@{$struct_hr->{'references'}}
		],
		'rank' => $struct_hr->{'rank'},
	);

	return $obj;
}

sub _obj_array_ref2struct {
	my ($snaks_ar) = @_;

	my $snaks_hr = {
		'qualifiers-order' => [],
		'qualifiers' => {},
	};
	foreach my $snak_o (@{$snaks_ar}) {
		if (! exists $snaks_hr->{'qualifiers'}->{$snak_o->property}) {
			$snaks_hr->{'qualifiers'}->{$snak_o->property} = [];
		}
		if (! @{$snaks_hr->{'qualifiers-order'}}
			|| none { $_ eq $snak_o->property } @{$snaks_hr->{'qualifiers-order'}}) {

			push @{$snaks_hr->{'qualifiers-order'}}, $snak_o->property;
		}
		push @{$snaks_hr->{'qualifiers'}->{$snak_o->property}},
			Wikidata::Datatype::Struct::Snak::obj2struct($snak_o);
	}

	return $snaks_hr;
}

sub _struct2qualifiers_array_ref {
	my $struct_hr = shift;

	my $qualifiers_ar = [];
	foreach my $property (@{$struct_hr->{'qualifiers-order'}}) {
		push @{$qualifiers_ar}, map {
			Wikidata::Datatype::Struct::Snak::struct2obj($_);
		} @{$struct_hr->{'qualifiers'}->{$property}};
	}

	return $qualifiers_ar;
}

1;

__END__
