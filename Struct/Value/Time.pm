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

	if (! exists $struct_hr->{'type'}
		|| $struct_hr->{'type'} ne 'time') {

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

=pod

=encoding utf8

=head1 NAME

Wikidata::Datatype::Struct::Value::Time - Wikidata time structure serialization.

=head1 SYNOPSIS

 use Wikidata::Datatype::Struct::Value::Time qw(obj2struct struct2obj);

 my $struct_hr = obj2struct($obj);
 my $obj = struct2obj($struct_hr);

=head1 DESCRIPTION

This conversion is between objects defined in Wikidata::Datatype and structures
serialized via JSON to MediaWiki.

=head1 SUBROUTINES

=head2 C<obj2struct>

 my $struct_hr = obj2struct($obj);

Convert Wikidata::Datatype::Value::Time instance to structure.

Returns reference to hash with structure.

=head2 C<struct2obj>

 my $obj = struct2obj($struct_hr);

Convert structure of time to object.

Returns Wikidata::Datatype::Value::Time istance.

=head1 ERRORS

 obj2struct():
         Object isn't 'Wikidata::Datatype::Value::Time'.

 struct2obj():
         Structure isn't for 'time' datatype.

=head1 EXAMPLE1

 use strict;
 use warnings;

 use Data::Printer;
 use Wikidata::Datatype::Value::Time;
 use Wikidata::Datatype::Struct::Value::Time qw(obj2struct);

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

 use Wikidata::Datatype::Struct::Value::Time qw(struct2obj);

 # String structure.
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
L<URL>,
L<Wikidata::Datatype::Value::Time>.

=head1 SEE ALSO

=over

=item L<Wikidata::Datatype::Struct>

Wikidata structure serialization.

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
