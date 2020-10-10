package Wikidata::Datatype::Struct::Value::Quantity;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;
use URI;
use Wikidata::Datatype::Value::Quantity;

Readonly::Array our @EXPORT_OK => qw(obj2struct struct2obj);

our $VERSION = 0.01;

sub obj2struct {
	my ($obj, $base_uri) = @_;

	if (! $obj->isa('Wikidata::Datatype::Value::Quantity')) {
		err "Object isn't 'Wikidata::Datatype::Value::Quantity'.";
	}

	my $amount = $obj->value;
	$amount = _add_plus($amount);
	my $unit;
	if (defined $obj->unit) {
		$unit = $base_uri.$obj->unit;
	} else {
		$unit = 1;
	}
	my $struct_hr = {
		'value' => {
			'amount' => $amount,
			defined $obj->lower_bound ? (
				'lowerBound' => _add_plus($obj->lower_bound),
			) : (),
			'unit' => $unit,
			defined $obj->upper_bound ? (
				'upperBound' => _add_plus($obj->upper_bound),
			) : (),
		},
		'type' => 'quantity',
	};

	return $struct_hr;
}

sub struct2obj {
	my $struct_hr = shift;

	if ($struct_hr->{'type'} ne 'quantity') {
		err "Structure isn't for 'quantity' datatype.";
	}

	my $amount = $struct_hr->{'value'}->{'amount'};
	$amount = _remove_plus($amount);
	my $unit = $struct_hr->{'value'}->{'unit'};
	if ($unit eq 1) {
		$unit = undef;
	} else {
		my $u = URI->new($unit);
		my @path_segments = $u->path_segments;
		$unit = $path_segments[-1];
	}
	my $obj = Wikidata::Datatype::Value::Quantity->new(
		$struct_hr->{'value'}->{'lowerBound'} ? (
			'lower_bound' => _remove_plus($struct_hr->{'value'}->{'lowerBound'}),
		) : (),
		'unit' => $unit,
		$struct_hr->{'value'}->{'upperBound'} ? (
			'upper_bound' => _remove_plus($struct_hr->{'value'}->{'upperBound'}),
		) : (),
		'value' => $amount,
	);

	return $obj;
}

sub _add_plus {
	my $value = shift;

	if ($value =~ m/^\d+$/) {
		$value = '+'.$value;
	}

	return $value;
}

sub _remove_plus {
	my $value = shift;

	if ($value =~ m/^\+(\d+)$/ms) {
		$value = $1;
	}

	return $value;
}

1;

__END__
