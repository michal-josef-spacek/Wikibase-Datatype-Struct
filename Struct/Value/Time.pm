package Wikidata::Datatype::Struct::Value::Time;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;
use URI;
use Wikidata::Datatype::Value::Time;

Readonly::Array our @EXPORT_OK => qw(obj2struct struct2obj);

our $VERSION = 0.01;

sub obj2struct {
	my ($obj, $base_uri) = @_;

	if (! $obj->isa('Wikidata::Datatype::Value::Time')) {
		err "Object isn't 'Wikidata::Datatype::Value::Time'.";
	}

	my $struct_hr = {
		'value' => {
			'after' => $obj->after,
			'before' => $obj->before,
			'calendarmodel' => $base_uri.$obj->calendarmodel,
			'precision' => $obj->precision,
			'time' => $obj->value,
			'timezone' => $obj->timezone,
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

	my $u = URI->new($struct_hr->{'value'}->{'calendarmodel'});
	my @path_segments = $u->path_segments;
	my $calendar_model = $path_segments[-1];
	my $obj = Wikidata::Datatype::Value::Time->new(
		'after' => $struct_hr->{'value'}->{'after'},
		'before' => $struct_hr->{'value'}->{'before'},
		'calendarmodel' => $calendar_model,
		'precision' => $struct_hr->{'value'}->{'precision'},
		'timezone' => $struct_hr->{'value'}->{'timezone'},
		'value' => $struct_hr->{'value'}->{'time'},
	);

	return $obj;
}

1;

__END__
