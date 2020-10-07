package Wikidata::Datatype::Struct::Utils;

use base qw(Exporter);
use strict;
use warnings;

use List::MoreUtils qw(none);
use Wikidata::Datatype::Struct::Snak;

Readonly::Array our @EXPORT_OK => qw(obj_array_ref2struct struct2snaks_array_ref);

our $VERSION = 0.01;

sub obj_array_ref2struct {
	my ($snaks_ar, $key) = @_;

	my $snaks_hr = {
		$key.'-order' => [],
		$key => {},
	};
	foreach my $snak_o (@{$snaks_ar}) {
		if (! exists $snaks_hr->{$key}->{$snak_o->property}) {
			$snaks_hr->{$key}->{$snak_o->property} = [];
		}
		if (! @{$snaks_hr->{$key.'-order'}}
			|| none { $_ eq $snak_o->property } @{$snaks_hr->{$key.'-order'}}) {

			push @{$snaks_hr->{$key.'-order'}}, $snak_o->property;
		}
		push @{$snaks_hr->{$key}->{$snak_o->property}},
			Wikidata::Datatype::Struct::Snak::obj2struct($snak_o);
	}

	return $snaks_hr;
}

sub struct2snaks_array_ref {
	my ($struct_hr, $key) = @_;

	my $snaks_ar = [];
	foreach my $property (@{$struct_hr->{$key.'-order'}}) {
		push @{$snaks_ar}, map {
			Wikidata::Datatype::Struct::Snak::struct2obj($_);
		} @{$struct_hr->{$key}->{$property}};
	}

	return $snaks_ar;
}

1;

__END__
