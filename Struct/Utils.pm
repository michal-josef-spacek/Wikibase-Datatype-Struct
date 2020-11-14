package Wikidata::Datatype::Struct::Utils;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use List::MoreUtils qw(none);
use Wikidata::Datatype::Struct::Snak;

Readonly::Array our @EXPORT_OK => qw(obj_array_ref2struct struct2snaks_array_ref);

our $VERSION = 0.01;

sub obj_array_ref2struct {
	my ($snaks_ar, $key, $base_uri) = @_;

	my $snaks_hr = {
		$key.'-order' => [],
		$key => {},
	};
	foreach my $snak_o (@{$snaks_ar}) {
		if (! $snak_o->isa('Wikidata::Datatype::Snak')) {
			err "Object isn't 'Wikidata::Datatype::Snak'.";
		}

		if (! exists $snaks_hr->{$key}->{$snak_o->property}) {
			$snaks_hr->{$key}->{$snak_o->property} = [];
		}
		if (! @{$snaks_hr->{$key.'-order'}}
			|| none { $_ eq $snak_o->property } @{$snaks_hr->{$key.'-order'}}) {

			push @{$snaks_hr->{$key.'-order'}}, $snak_o->property;
		}
		push @{$snaks_hr->{$key}->{$snak_o->property}},
			Wikidata::Datatype::Struct::Snak::obj2struct($snak_o, $base_uri);
	}

	return $snaks_hr;
}

sub struct2snaks_array_ref {
	my ($struct_hr, $key) = @_;

	my $snaks_ar = [];
	foreach my $property (@{$struct_hr->{$key.'-order'}}) {
		push @{$snaks_ar}, map {
			Wikidata::Datatype::Struct::Snak::struct2obj($_);
		} @{$struct_hr->{$key}->{$property}};
	}

	return $snaks_ar;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Wikidata::Datatype::Struct::Utils - Wikidata structure serialization utilities.

=head1 SYNOPSIS

 use Wikidata::Datatype::Struct::Utils qw(obj_array_ref2struct struct2snaks_array_ref);

 my $snaks_hr = obj_array_ref2struct($snaks_ar, $key, $base_uri);
 my $snaks_ar = struct2snaks_array_ref($struct_hr, $key);

=head1 SUBROUTINES

=head2 C<obj_array_ref2struct>

 my $snaks_hr = obj_array_ref2struct($snaks_ar, $key, $base_uri);

Helper subroutine for converting list of Snak objects to snaks structure.
This subroutine is used in Statement and Reference module.

Returns structure with multiple snaks.

=head2 C<struct2snaks_array_ref>

 my $snaks_ar = struct2snaks_array_ref($struct_hr, $key);

Helper subroutine for converting snaks structure to list of Snak objects.
This subroutine is used in Statement and Reference module.

Returns reference to array with snaks objects.

=head1 ERRORS

 obj_array_ref2struct():
         Object isn't 'Wikidata::Datatype::Snak'.

 struct2snaks_array_ref():
         From Wikidata::Datatype::Snak::new():
                 From Wikidata::Datatype::Utils::check_required():
                         Parameter 'datatype' is required.
                         Parameter 'datavalue' is required.
                         Parameter 'property' is required.
                 From Wikidata::Datatype::Utils::check_isa():
                         Parameter 'datavalue' must be a 'Wikidata::Datatype::Value::%s' object.
                 Parameter 'datatype' = '%s' isn't supported.
                 Parameter 'property' must begin with 'P' and number after it.
                 Parameter 'snaktype' = '%s' isn't supported.
         From Wikidata::Datatype::Struct::Snak::struct2obj():
                 From Wikidata::Datatype::Struct::Value::struct2obj():
                         Entity type '%s' is unsupported.
                         Type doesn't exist.
                         Type '%s' is unsupported.

=head1 EXAMPLE1

 use strict;
 use warnings;

 use Data::Printer;
 use Wikidata::Datatype::Snak;
 use Wikidata::Datatype::Struct::Utils qw(obj_array_ref2struct);
 use Wikidata::Datatype::Value::Item;
 use Wikidata::Datatype::Value::String;

 my $snak1 = Wikidata::Datatype::Snak->new(
         'datatype' => 'wikibase-item',
         'datavalue' => Wikidata::Datatype::Value::Item->new(
                 'value' => 'Q5',
         ),
         'property' => 'P31',
 );
 my $snak2 = Wikidata::Datatype::Snak->new(
         'datatype' => 'math',
         'datavalue' => Wikidata::Datatype::Value::String->new(
                 'value' => 'E = m c^2',
         ),
         'property' => 'P2534',
 );

 # Convert list of snak objects to structure.
 my $snaks_ar = obj_array_ref2struct([$snak1, $snak2], 'snaks',
         'http://test.wikidata.org/entity/');

 # Dump to output.
 p $snaks_ar;

 # Output:
 # \ {
 #     snaks         {
 #         P31     [
 #             [0] {
 #                 datatype    "wikibase-item",
 #                 datavalue   {
 #                     type    "wikibase-entityid",
 #                     value   {
 #                         entity-type   "item",
 #                         id            "Q5",
 #                         numeric-id    5
 #                     }
 #                 },
 #                 property    "P31",
 #                 snaktype    "value"
 #             }
 #         ],
 #         P2534   [
 #             [0] {
 #                 datatype    "math",
 #                 datavalue   {
 #                     type    "string",
 #                     value   "E = m c^2"
 #                 },
 #                 property    "P2534",
 #                 snaktype    "value"
 #             }
 #         ]
 #     },
 #     snaks-order   [
 #         [0] "P31",
 #         [1] "P2534"
 #     ]
 # }

=head1 EXAMPLE2

 use strict;
 use warnings;

 use Wikidata::Datatype::Struct::Utils qw(struct2snaks_array_ref);

 my $struct_hr = {
         'snaks' => {
                 'P31' => [{
                         'datatype' => 'wikibase-item',
                         'datavalue' => {
                                 'type' => 'wikibase-entityid',
                                 'value' => {
                                         'entity-type' => 'item',
                                         'id' => 'Q5',
                                         'numeric-id' => 5,
                                 },
                         },
                         'property' => 'P31',
                         'snaktype' => 'value',

                 }],
                 'P2534' => [{
                         'datatype' => 'math',
                         'datavalue' => {
                                 'type' => 'string',
                                 'value' => 'E = m c^2',
                         },
                         'property' => 'P2534',
                         'snaktype' => 'value',
                 }],
         },
         'snaks-order' => [
                 'P31',
                 'P2534',
         ],
 };

 # Convert snaks structure to list of Snak objects.
 my $snaks_ar = struct2snaks_array_ref($struct_hr, 'snaks');

 # Print out. 
 foreach my $snak (@{$snaks_ar}) {
         print 'Property: '.$snak->property."\n";
         print 'Type: '.$snak->datatype."\n";
         print 'Value: '.$snak->datavalue->value."\n";
         print "\n";
 }

 # Output:
 # Property: P31
 # Type: wikibase-item
 # Value: Q5
 #
 # Property: P2534
 # Type: math
 # Value: E = m c^2
 #

=head1 DEPENDENCIES

L<Error::Pure>,
L<Exporter>,
L<List::MoreUtils>,
L<Wikidata::Datatype::Struct::Snak>.

=head1 SEE ALSO

=over

=item L<Wikidata::Datatype::Struct>

Wikidata structure serialization.

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
