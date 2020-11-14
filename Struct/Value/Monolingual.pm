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

	if (! exists $struct_hr->{'type'}
		|| $struct_hr->{'type'} ne 'monolingualtext') {

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

=pod

=encoding utf8

=head1 NAME

Wikidata::Datatype::Struct::Value::Monolingual - Wikidata monolingual structure serialization.

=head1 SYNOPSIS

 use Wikidata::Datatype::Struct::Value::Monolingual qw(obj2struct struct2obj);

 my $struct_hr = obj2struct($obj);
 my $obj = struct2obj($struct_hr);

=head1 DESCRIPTION

This conversion is between objects defined in Wikidata::Datatype and structures
serialized via JSON to MediaWiki.

=head1 SUBROUTINES

=head2 C<obj2struct>

 my $struct_hr = obj2struct($obj);

Convert Wikidata::Datatype::Value::Monolingual instance to structure.

Returns reference to hash with structure.

=head2 C<struct2obj>

 my $obj = struct2obj($struct_hr);

Convert structure of monolingual to object.

Returns Wikidata::Datatype::Value::Monolingual istance.

=head1 ERRORS

 obj2struct():
         Object isn't 'Wikidata::Datatype::Value::Monolingual'.

 struct2obj():
         Structure isn't for 'monolingualtext' datatype.

=head1 EXAMPLE1

 use strict;
 use warnings;

 use Data::Printer;
 use Wikidata::Datatype::Value::Monolingual;
 use Wikidata::Datatype::Struct::Value::Monolingual qw(obj2struct);

 # Object.
 my $obj = Wikidata::Datatype::Value::Monolingual->new(
         'language' => 'en',
         'value' => 'English text',
 );

 # Get structure.
 my $struct_hr = obj2struct($obj);

 # Dump to output.
 p $struct_hr;

 # Output:
 # \ {
 #     type    "monolingualtext",
 #     value   {
 #         language   "en",
 #         text       "English text"
 #     }
 # }

=head1 EXAMPLE2

 use strict;
 use warnings;

 use Data::Printer;
 use Wikidata::Datatype::Struct::Value::Monolingual qw(struct2obj);

 # Monolingualtext structure.
 my $struct_hr = {
         'type' => 'monolingualtext',
         'value' => {
                 'language' => 'en',
                 'text' => 'English text',
         },
 };

 # Get object.
 my $obj = struct2obj($struct_hr);

 # Get language.
 my $language = $obj->language;

 # Get type.
 my $type = $obj->type;

 # Get value.
 my $value = $obj->value;

 # Print out.
 print "Language: $language\n";
 print "Type: $type\n";
 print "Value: $value\n";

 # Output:
 # Language: en
 # Type: monolingualtext
 # Value: English text

=head1 DEPENDENCIES

L<Error::Pure>,
L<Exporter>,
L<Readonly>,
L<Wikidata::Datatype::Value::Monolingual>.

=head1 SEE ALSO

=over

=item L<Wikidata::Datatype::Struct>

Wikidata structure serialization.

=item L<Wikidata::Datatype::Value::Monolingual>

Wikidata monolingual value datatype.

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
