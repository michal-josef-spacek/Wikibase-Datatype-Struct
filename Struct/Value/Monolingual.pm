package Wikidata::Datatype::Struct::Value::Monolingual;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;
use Wikidata::Datatype::Value::Monolingual;

Readonly::Array our @EXPORT_OK => qw(obj2struct struct2obj);

our $VERSION = 0.01;

sub obj2struct {
	my $obj = shift;

	if (! $obj->isa('Wikidata::Datatype::Value::Monolingual')) {
		err "Object isn't 'Wikidata::Datatype::Value::Monolingual'.";
	}

	my $struct_hr = {
		'value' => {
			'language' => $obj->language,
			'text' => $obj->value,
		},
		'type' => 'monolingualtext',
	};

	return $struct_hr;
}

sub struct2obj {
	my $struct_hr = shift;

	if ($struct_hr->{'type'} ne 'monolingualtext') {
		err "Structure isn't for 'monolingualtext' datatype.";
	}

	my $obj = Wikidata::Datatype::Value::Monolingual->new(
		'language' => $struct_hr->{'value'}->{'language'},
		'value' => $struct_hr->{'value'}->{'text'},
	);

	return $obj;
}

1;

__END__
