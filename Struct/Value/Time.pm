package Wikidata::Datatype::Struct::Value::Time;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;
use Wikidata::Datatype::Value::Time;

Readonly::Array our @EXPORT_OK => qw(obj2struct struct2obj);

our $VERSION = 0.01;

sub obj2struct {
	my $obj = shift;

	if (! $obj->isa('Wikidata::Datatype::Value::Time')) {
		err "Object isn't 'Wikidata::Datatype::Value::Time'.";
	}

	my $struct_hr = {
		'value' => {
			'after' => $obj->after,
			'time' => $obj->value,
			'before' => $obj->before,
			'timezone' => $obj->timezone,
			'precision' => $obj->precision,
			'calendarmodel' => 'http://www.wikidata.org/entity/Q1985727',
		},
		'type' => 'time',
	};

	return $struct_hr;
}

sub struct2obj {
	my $struct_hr = shift;

	if ($struct_hr->{'type'} ne 'time') {
		err "Structure isn't for 'time' datatype.";
	}

	# TODO precision
	my $obj = Wikidata::Datatype::Value::Time->new(
		'value' => $struct_hr->{'value'},
	);

	return $obj;
}

1;

__END__
