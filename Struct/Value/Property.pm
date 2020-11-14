package Wikidata::Datatype::Struct::Value::Property;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;
use Wikidata::Datatype::Value::Property;

Readonly::Array our @EXPORT_OK => qw(obj2struct struct2obj);

our $VERSION = 0.01;

sub obj2struct {
	my $obj = shift;

	if (! $obj->isa('Wikidata::Datatype::Value::Property')) {
		err "Object isn't 'Wikidata::Datatype::Value::Property'.";
	}

	my $numeric_id = $obj->value;
	$numeric_id =~ s/^P//ms;
	my $struct_hr = {
		'value' => {
			'entity-type' => 'property',
			'id' => $obj->value,
			'numeric-id' => $numeric_id,
		},
		'type' => 'wikibase-entityid',
	};

	return $struct_hr;
}

sub struct2obj {
	my $struct_hr = shift;

	if (! exists $struct_hr->{'type'}
		|| $struct_hr->{'type'} ne 'wikibase-entityid'
		|| ! exists $struct_hr->{'value'}->{'entity-type'}
		|| $struct_hr->{'value'}->{'entity-type'} ne 'property') {

		err "Structure isn't for 'property' datatype.";
	}

	my $obj = Wikidata::Datatype::Value::Property->new(
		'value' => $struct_hr->{'value'}->{'id'},
	);

	return $obj;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Wikidata::Datatype::Struct::Value::Property - Wikidata property structure serialization.

=head1 SYNOPSIS

 use Wikidata::Datatype::Struct::Value::Property qw(obj2struct struct2obj);

 my $struct_hr = obj2struct($obj);
 my $obj = struct2obj($struct_hr);

=head1 DESCRIPTION

This conversion is between objects defined in Wikidata::Datatype and structures
serialized via JSON to MediaWiki.

=head1 SUBROUTINES

=head2 C<obj2struct>

 my $struct_hr = obj2struct($obj);

Convert Wikidata::Datatype::Value::Property instance to structure.

Returns reference to hash with structure.

=head2 C<struct2obj>

 my $obj = struct2obj($struct_hr);

Convert structure of property to object.

Returns Wikidata::Datatype::Value::Property istance.

=head1 ERRORS

 obj2struct():
         Object isn't 'Wikidata::Datatype::Value::Property'.

 struct2obj():
         Structure isn't for 'property' datatype.

=head1 EXAMPLE1

 use strict;
 use warnings;

 use Data::Printer;
 use Wikidata::Datatype::Value::Property;
 use Wikidata::Datatype::Struct::Value::Property qw(obj2struct);

 # Object.
 my $obj = Wikidata::Datatype::Value::Property->new(
         'value' => 'P123',
 );

 # Get structure.
 my $struct_hr = obj2struct($obj);

 # Dump to output.
 p $struct_hr;

 # Output:
 # \ {
 #     type    "wikibase-entityid",
 #     value   {
 #         entity-type   "property",
 #         id            "P123",
 #         numeric-id    123
 #     }
 # }

=head1 EXAMPLE2

 use strict;
 use warnings;

 use Wikidata::Datatype::Struct::Value::Property qw(struct2obj);

 # Property structure.
 my $struct_hr = {
         'type' => 'wikibase-entityid',
         'value' => {
                 'entity-type' => 'property',
                 'id' => 'P123',
                 'numeric-id' => 123,
         },
 };

 # Get object.
 my $obj = struct2obj($struct_hr);

 # Get value.
 my $value = $obj->value;

 # Get type.
 my $type = $obj->type;

 # Print out.
 print "Type: $type\n";
 print "Value: $value\n";

 # Output:
 # Type: property
 # Value: P123

=head1 DEPENDENCIES

L<Error::Pure>,
L<Exporter>,
L<Readonly>,
L<Wikidata::Datatype::Value::Property>.

=head1 SEE ALSO

=over

=item L<Wikidata::Datatype::Struct>

Wikidata structure serialization.

=item L<Wikidata::Datatype::Value::Property>

Wikidata property value datatype.

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
