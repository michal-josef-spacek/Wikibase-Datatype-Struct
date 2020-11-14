package Wikidata::Datatype::Struct::Value;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;
use Wikidata::Datatype::Value;
use Wikidata::Datatype::Struct::Value::Globecoordinate;
use Wikidata::Datatype::Struct::Value::Item;
use Wikidata::Datatype::Struct::Value::Monolingual;
use Wikidata::Datatype::Struct::Value::Property;
use Wikidata::Datatype::Struct::Value::Quantity;
use Wikidata::Datatype::Struct::Value::String;
use Wikidata::Datatype::Struct::Value::Time;

Readonly::Array our @EXPORT_OK => qw(obj2struct struct2obj);

our $VERSION = 0.01;

sub obj2struct {
	my ($obj, $base_uri) = @_;

	if (! $obj->isa('Wikidata::Datatype::Value')) {
		err "Object isn't 'Wikidata::Datatype::Value'.";
	}

	my $struct_hr;
	my $type = $obj->type;
	if ($type eq 'globecoordinate') {
		$struct_hr = Wikidata::Datatype::Struct::Value::Globecoordinate::obj2struct($obj, $base_uri);
	} elsif ($type eq 'item') {
		$struct_hr = Wikidata::Datatype::Struct::Value::Item::obj2struct($obj);
	} elsif ($type eq 'monolingualtext') {
		$struct_hr = Wikidata::Datatype::Struct::Value::Monolingual::obj2struct($obj);
	} elsif ($type eq 'property') {
		$struct_hr = Wikidata::Datatype::Struct::Value::Property::obj2struct($obj);
	} elsif ($type eq 'quantity') {
		$struct_hr = Wikidata::Datatype::Struct::Value::Quantity::obj2struct($obj, $base_uri);
	} elsif ($type eq 'string') {
		$struct_hr = Wikidata::Datatype::Struct::Value::String::obj2struct($obj);
	} elsif ($type eq 'time') {
		$struct_hr = Wikidata::Datatype::Struct::Value::Time::obj2struct($obj, $base_uri);
	} else {
		err "Type '$type' is unsupported.";
	}

	return $struct_hr;
}

sub struct2obj {
	my $struct_hr = shift;

	if (! exists $struct_hr->{'type'}) {
		err "Type doesn't exist.";
	}

	my $obj;
	if ($struct_hr->{'type'} eq 'globecoordinate') {
		$obj = Wikidata::Datatype::Struct::Value::Globecoordinate::struct2obj($struct_hr);
	} elsif ($struct_hr->{'type'} eq 'monolingualtext') {
		$obj = Wikidata::Datatype::Struct::Value::Monolingual::struct2obj($struct_hr);
	} elsif ($struct_hr->{'type'} eq 'quantity') {
		$obj = Wikidata::Datatype::Struct::Value::Quantity::struct2obj($struct_hr);
	} elsif ($struct_hr->{'type'} eq 'string') {
		$obj = Wikidata::Datatype::Struct::Value::String::struct2obj($struct_hr);
	} elsif ($struct_hr->{'type'} eq 'time') {
		$obj = Wikidata::Datatype::Struct::Value::Time::struct2obj($struct_hr);
	} elsif ($struct_hr->{'type'} eq 'wikibase-entityid') {
		if ($struct_hr->{'value'}->{'entity-type'} eq 'item') {
			$obj = Wikidata::Datatype::Struct::Value::Item::struct2obj($struct_hr);
		} elsif ($struct_hr->{'value'}->{'entity-type'} eq 'property') {
			$obj = Wikidata::Datatype::Struct::Value::Property::struct2obj($struct_hr);
		} else {
			err "Entity type '$struct_hr->{'value'}->{'entity-type'}' is unsupported.";
		}
	} else {
		err "Type '$struct_hr->{'type'}' is unsupported.";
	}

	return $obj;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Wikidata::Datatype::Struct::Value - Wikidata value structure serialization.

=head1 SYNOPSIS

 use Wikidata::Datatype::Struct::Value qw(obj2struct struct2obj);

 my $struct_hr = obj2struct($obj);
 my $obj = struct2obj($struct_hr);

=head1 DESCRIPTION

This conversion is between objects defined in Wikidata::Datatype and structures
serialized via JSON to MediaWiki.

=head1 SUBROUTINES

=head2 C<obj2struct>

 my $struct_hr = obj2struct($obj);

Convert Wikidata::Datatype::Value instance to structure.

Returns reference to hash with structure.

=head2 C<struct2obj>

 my $obj = struct2obj($struct_hr);

Convert structure of value to object.

Returns Wikidata::Datatype::Value istance.

=head1 ERRORS

 obj2struct():
         Object isn't 'Wikidata::Datatype::Value'.
         Type '%s' is unsupported.

 struct2obj():
         Entity type '%s' is unsupported.
         Type doesn't exist.
         Type '%s' is unsupported.

=head1 EXAMPLE1

 use strict;
 use warnings;

 use Data::Printer;
 use Wikidata::Datatype::Value::Time;
 use Wikidata::Datatype::Struct::Value qw(obj2struct);

 # Object.
 my $obj = Wikidata::Datatype::Value::Time->new(
         'precision' => 10,
         'value' => '+2020-09-01T00:00:00Z',
 );

 # Get structure.
 my $struct_hr = obj2struct($obj, 'http://test.wikidata.org/entity/');

 # Dump to output.
 p $struct_hr;

 # Output:
 # \ {
 #     type    "time",
 #     value   {
 #         after           0,
 #         before          0,
 #         calendarmodel   "http://test.wikidata.org/entity/Q1985727",
 #         precision       10,
 #         time            "+2020-09-01T00:00:00Z",
 #         timezone        0
 #     }
 # }

=head1 EXAMPLE2

 use strict;
 use warnings;

 use Wikidata::Datatype::Struct::Value qw(struct2obj);

 # Time structure.
 my $struct_hr = {
         'type' => 'time',
         'value' => {
                 'after' => 0,
                 'before' => 0,
                 'calendarmodel' => 'http://test.wikidata.org/entity/Q1985727',
                 'precision' => 10,
                 'time' => '+2020-09-01T00:00:00Z',
                 'timezone' => 0,
         },
 };

 # Get object.
 my $obj = struct2obj($struct_hr);

 # Get calendar model.
 my $calendarmodel = $obj->calendarmodel;

 # Get precision.
 my $precision = $obj->precision;

 # Get type.
 my $type = $obj->type;

 # Get value.
 my $value = $obj->value;

 # Print out.
 print "Calendar model: $calendarmodel\n";
 print "Precision: $precision\n";
 print "Type: $type\n";
 print "Value: $value\n";

 # Output:
 # Calendar model: Q1985727
 # Precision: 10
 # Type: time
 # Value: +2020-09-01T00:00:00Z

=head1 DEPENDENCIES

L<Error::Pure>,
L<Exporter>,
L<Readonly>,
L<Wikidata::Datatype::Value>,
L<Wikidata::Datatype::Struct::Value::Globecoordinate>,
L<Wikidata::Datatype::Struct::Value::Item>,
L<Wikidata::Datatype::Struct::Value::Monolingual>,
L<Wikidata::Datatype::Struct::Value::Property>,
L<Wikidata::Datatype::Struct::Value::Quantity>,
L<Wikidata::Datatype::Struct::Value::String>,
L<Wikidata::Datatype::Struct::Value::Time>.

=head1 SEE ALSO

=over

=item L<Wikidata::Datatype::Struct>

Wikidata structure serialization.

=item L<Wikidata::Datatype::Value::Globecoordinate>

Wikidata globe coordinate value datatype.

=item L<Wikidata::Datatype::Value::Item>

Wikidata item value datatype.

=item L<Wikidata::Datatype::Value::Monolingual>

Wikidata monolingual value datatype.

=item L<Wikidata::Datatype::Value::Property>

Wikidata property value datatype.

=item L<Wikidata::Datatype::Value::Quantity>

Wikidata quantity value datatype.

=item L<Wikidata::Datatype::Value::String>

Wikidata string value datatype.

=item L<Wikidata::Datatype::Value::Time>

Wikidata time value datatype.

=back

=head1 REPOSITORY

L<https://github.com/michal-josef-spacek/Wikidata-Datatype-Struct>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© Michal Josef Špaček 2020

BSD 2-Clause License

=head1 VERSION

0.01

=cut
