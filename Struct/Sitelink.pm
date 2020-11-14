package Wikidata::Datatype::Struct::Sitelink;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;
use Wikidata::Datatype::Sitelink;
use Wikidata::Datatype::Value::Item;

Readonly::Array our @EXPORT_OK => qw(obj2struct struct2obj);

our $VERSION = 0.01;

sub obj2struct {
	my $obj = shift;

	if (! $obj->isa('Wikidata::Datatype::Sitelink')) {
		err "Object isn't 'Wikidata::Datatype::Sitelink'.";
	}

	my $struct_hr = {
		'badges' => [
			map { $_->value } @{$obj->badges},
		],
		'site' => $obj->site,
		'title' => $obj->title,
	};

	return $struct_hr;
}

sub struct2obj {
	my ($struct_hr, $entity) = @_;

	my $obj = Wikidata::Datatype::Sitelink->new(
		'badges' => [
			map { Wikidata::Datatype::Value::Item->new('value' => $_); }
			@{$struct_hr->{'badges'}},
		],
		'site' => $struct_hr->{'site'},
		'title' => $struct_hr->{'title'},
	);

	return $obj;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Wikidata::Datatype::Struct::Sitelink - Wikidata sitelink structure serialization.

=head1 SYNOPSIS

 use Wikidata::Datatype::Struct::Sitelink qw(obj2struct struct2obj);

 my $struct_hr = obj2struct($obj);
 my $obj = struct2obj($struct_hr);

=head1 DESCRIPTION

This conversion is between objects defined in Wikidata::Datatype and structures
serialized via JSON to MediaWiki.

=head1 SUBROUTINES

=head2 C<obj2struct>

 my $struct_hr = obj2struct($obj);

Convert Wikidata::Datatype::Sitelink instance to structure.

Returns reference to hash with structure.

=head2 C<struct2obj>

 my $obj = struct2obj($struct_hr);

Convert structure of sitelink to object.

Returns Wikidata::Datatype::Sitelink instance.

=head1 ERRORS

 obj2struct():
         Object isn't 'Wikidata::Datatype::Sitelink'.

=head1 EXAMPLE1

 use strict;
 use warnings;

 use Data::Printer;
 use Wikidata::Datatype::Sitelink;
 use Wikidata::Datatype::Struct::Sitelink qw(obj2struct);

 # Object.
 my $obj = Wikidata::Datatype::Sitelink->new(
         'site' => 'enwiki',
         'title' => 'Main page',
 );

 # Get structure.
 my $struct_hr = obj2struct($obj);

 # Dump to output.
 p $struct_hr;

 # Output:
 # \ {
 #     badges   [],
 #     site     "enwiki",
 #     title    "Main page"
 # }

=head1 EXAMPLE2

 use strict;
 use warnings;

 use Wikidata::Datatype::Struct::Sitelink qw(struct2obj);

 # Item structure.
 my $struct_hr = {
         'badges' => [],
         'site' => 'enwiki',
         'title' => 'Main page',
 };

 # Get object.
 my $obj = struct2obj($struct_hr);

 # Get badges.
 my $badges_ar = [map { $_->value } @{$obj->badges}];

 # Get site.
 my $site = $obj->site;

 # Get title.
 my $title = $obj->title;

 # Print out.
 print 'Badges: '.(join ', ', @{$badges_ar})."\n";
 print "Site: $site\n";
 print "Title: $title\n";

 # Output:
 # Badges:
 # Site: enwiki
 # Title: Main page

=head1 DEPENDENCIES

L<Error::Pure>,
L<Exporter>,
L<Readonly>,
L<Wikidata::Datatype::Sitelink>,
L<Wikidata::Datatype::Value::Item>.

=head1 SEE ALSO

=over

=item L<Wikidata::Datatype::Struct>

Wikidata structure serialization.

=item L<Wikidata::Datatype::Sitelink>

Wikidata sitelink datatype.

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
