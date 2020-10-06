package Wikidata::Datatype::Struct::Reference;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use List::MoreUtils qw(none);
use Readonly;
use Wikidata::Datatype::Reference;
use Wikidata::Datatype::Struct::Snak;

Readonly::Array our @EXPORT_OK => qw(obj2struct struct2obj);

our $VERSION = 0.01;

sub obj2struct {
	my $obj = shift;

	if (! $obj->isa('Wikidata::Datatype::Reference')) {
		err "Object isn't 'Wikidata::Datatype::Reference'.";
	}

	my $struct_hr = _obj_array_ref2struct($obj->snaks);

	return $struct_hr;
}

sub struct2obj {
	my $struct_hr = shift;

	my $obj = Wikidata::Datatype::Reference->new(
		'snaks' => _struct2snaks_array_ref($struct_hr),
	);

	return $obj;
}

sub _struct2snaks_array_ref {
	my $struct_hr = shift;

	my $snaks_ar = [];
	foreach my $property (@{$struct_hr->{'snaks-order'}}) {
		push @{$snaks_ar}, map { 
			Wikidata::Datatype::Struct::Snak::struct2obj($_);
		} @{$struct_hr->{'snaks'}->{$property}};
	}

	return $snaks_ar;
}

sub _obj_array_ref2struct {
	my ($snaks_ar) = @_;

	my $snaks_hr = {
		'snaks-order' => [],
		'snaks' => {},
	};
	foreach my $snak_o (@{$snaks_ar}) {
		if (! exists $snaks_hr->{'snaks'}->{$snak_o->property}) {
			$snaks_hr->{'snaks'}->{$snak_o->property} = [];
		}
		if (! @{$snaks_hr->{'snaks-order'}}
			|| none { $_ eq $snak_o->property } @{$snaks_hr->{'snaks-order'}}) {

			push @{$snaks_hr->{'snaks-order'}}, $snak_o->property;
		}
		push @{$snaks_hr->{'snaks'}->{$snak_o->property}},
			Wikidata::Datatype::Struct::Snak::obj2struct($snak_o);
	}

	return $snaks_hr;
}

1;

__END__
