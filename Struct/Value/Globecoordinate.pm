package Wikidata::Datatype::Struct::Value::Globecoordinate;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;
use URI;
use Wikidata::Datatype::Value::Globecoordinate;

Readonly::Array our @EXPORT_OK => qw(obj2struct struct2obj);

our $VERSION = 0.01;

sub obj2struct {
	my ($obj, $base_uri) = @_;

	if (! $obj->isa('Wikidata::Datatype::Value::Globecoordinate')) {
		err "Object isn't 'Wikidata::Datatype::Value::Globecoordinate'.";
	}

	my $struct_hr = {
		'value' => {
			'altitude' => $obj->altitude ? $obj->altitude : 'null',
			'globe' => $base_uri.$obj->globe,
			'latitude' => $obj->latitude,
			'longitude' => $obj->longitude,
			'precision' => $obj->precision,
		},
		'type' => $obj->type,
	};

	return $struct_hr;
}

sub struct2obj {
	my $struct_hr = shift;

	if (! exists $struct_hr->{'type'}
		|| $struct_hr->{'type'} ne 'globecoordinate') {

		err "Structure isn't for 'globecoordinate' datatype.";
	}

	my $u = URI->new($struct_hr->{'value'}->{'globe'});
	my @path_segments = $u->path_segments;
	my $globe = $path_segments[-1];
	my $obj = Wikidata::Datatype::Value::Globecoordinate->new(
		$struct_hr->{'value'}->{'altitude'} ne 'null' ? (
			'altitude' => $struct_hr->{'value'}->{'altitude'},
		) : (),
		'globe' => $globe,
		'precision' => $struct_hr->{'value'}->{'precision'},
		'value' => [
			$struct_hr->{'value'}->{'latitude'},
			$struct_hr->{'value'}->{'longitude'},
		],
	);

	return $obj;
}

1;

__END__
