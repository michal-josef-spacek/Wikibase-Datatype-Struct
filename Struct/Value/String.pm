package Wikidata::Datatype::Struct::Value::String;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;
use Wikidata::Datatype::Value::String;

Readonly::Array our @EXPORT_OK => qw(obj2struct struct2obj);

our $VERSION = 0.01;

sub obj2struct {
	my $obj = shift;

	if (! $obj->isa('Wikidata::Datatype::Value::String')) {
		err "Object isn't 'Wikidata::Datatype::Value::String'.";
	}

	my $struct_hr = {
		'type' => 'string',
		'value' => $obj->value,
	};

	return $struct_hr;
}

sub struct2obj {
	my $struct_hr = shift;

	if (! exists $struct_hr->{'type'}
		|| $struct_hr->{'type'} ne 'string') {

		err "Structure isn't for 'string' datatype.";
	}

	my $obj = Wikidata::Datatype::Value::String->new(
		'value' => $struct_hr->{'value'},
	);

	return $obj;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Wikidata::Datatype::Struct::Value::String - Wikidata string structure serialization.

=head1 SYNOPSIS

 use Wikidata::Datatype::Struct::Value::String qw(obj2struct struct2obj);

 my $struct_hr = obj2struct($obj);
 my $obj = struct2obj($struct_hr);

=head1 DESCRIPTION

This conversion is between objects defined in Wikidata::Datatype and structures
serialized via JSON to MediaWiki.

=head1 SUBROUTINES

=head2 C<obj2struct>

 my $struct_hr = obj2struct($obj);

Convert Wikidata::Datatype::Value::Strin instance to structure.

Returns reference to hash with structure.

=head2 C<struct2obj>

 my $obj = struct2obj($struct_hr);

Convert structure of string to object.

Returns Wikidata::Datatype::Value::String istance.

=head1 ERRORS

 obj2struct():
         Object isn't 'Wikidata::Datatype::Value::String'.

 struct2obj():
         Structure isn't for 'string' datatype.

=head1 EXAMPLE1

 use strict;
 use warnings;

 use Data::Printer;
 use Wikidata::Datatype::Value::String;
 use Wikidata::Datatype::Struct::Value::String qw(obj2struct);

 # Object.
 my $obj = Wikidata::Datatype::Value::String->new(
         'value' => 'foo',
 );

 # Get structure.
 my $struct_hr = obj2struct($obj);

 # Dump to output.
 p $struct_hr;

 # Output:
 # \ {
 #     type    "string",
 #     value   "foo"
 # }

=head1 EXAMPLE2

 use strict;
 use warnings;

 use Data::Printer;
 use Wikidata::Datatype::Struct::Value::String qw(struct2obj);

 # String structure.
 my $struct_hr = {
         'type' => 'string',
         'value' => 'foo',
 };

 # Get object.
 my $obj = struct2obj($struct_hr);

 # Get type.
 my $type = $obj->type;

 # Get value.
 my $value = $obj->value;

 # Print out.
 print "Type: $type\n";
 print "Value: $value\n";

 # Output:
 # Type: string
 # Value: foo

=head1 DEPENDENCIES

L<Error::Pure>,
L<Exporter>,
L<Readonly>,
L<Wikidata::Datatype::Value::String>.

=head1 SEE ALSO

=over

=item L<Wikidata::Datatype::Struct>

Wikidata structure serialization.

=item L<Wikidata::Datatype::Value::String>

Wikidata string value datatype.

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
