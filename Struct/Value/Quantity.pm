package Wikidata::Datatype::Struct::Value::Quantity;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;
use URI;
use Wikidata::Datatype::Value::Quantity;

Readonly::Array our @EXPORT_OK => qw(obj2struct struct2obj);

our $VERSION = 0.01;

sub obj2struct {
	my ($obj, $base_uri) = @_;

	if (! $obj->isa('Wikidata::Datatype::Value::Quantity')) {
		err "Object isn't 'Wikidata::Datatype::Value::Quantity'.";
	}

	my $amount = $obj->value;
	$amount = _add_plus($amount);
	my $unit;
	if (defined $obj->unit) {
		$unit = $base_uri.$obj->unit;
	} else {
		$unit = 1;
	}
	my $struct_hr = {
		'value' => {
			'amount' => $amount,
			defined $obj->lower_bound ? (
				'lowerBound' => _add_plus($obj->lower_bound),
			) : (),
			'unit' => $unit,
			defined $obj->upper_bound ? (
				'upperBound' => _add_plus($obj->upper_bound),
			) : (),
		},
		'type' => 'quantity',
	};

	return $struct_hr;
}

sub struct2obj {
	my $struct_hr = shift;

	if (! exists $struct_hr->{'type'}
		|| $struct_hr->{'type'} ne 'quantity') {

		err "Structure isn't for 'quantity' datatype.";
	}

	my $amount = $struct_hr->{'value'}->{'amount'};
	$amount = _remove_plus($amount);
	my $unit = $struct_hr->{'value'}->{'unit'};
	if ($unit eq 1) {
		$unit = undef;
	} else {
		my $u = URI->new($unit);
		my @path_segments = $u->path_segments;
		$unit = $path_segments[-1];
	}
	my $obj = Wikidata::Datatype::Value::Quantity->new(
		$struct_hr->{'value'}->{'lowerBound'} ? (
			'lower_bound' => _remove_plus($struct_hr->{'value'}->{'lowerBound'}),
		) : (),
		'unit' => $unit,
		$struct_hr->{'value'}->{'upperBound'} ? (
			'upper_bound' => _remove_plus($struct_hr->{'value'}->{'upperBound'}),
		) : (),
		'value' => $amount,
	);

	return $obj;
}

sub _add_plus {
	my $value = shift;

	if ($value =~ m/^\d+$/) {
		$value = '+'.$value;
	}

	return $value;
}

sub _remove_plus {
	my $value = shift;

	if ($value =~ m/^\+(\d+)$/ms) {
		$value = $1;
	}

	return $value;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Wikidata::Datatype::Struct::Value::Quantity - Wikidata quantity structure serialization.

=head1 SYNOPSIS

 use Wikidata::Datatype::Struct::Value::Quantity qw(obj2struct struct2obj);

 my $struct_hr = obj2struct($obj);
 my $obj = struct2obj($struct_hr);

=head1 DESCRIPTION

This conversion is between objects defined in Wikidata::Datatype and structures
serialized via JSON to MediaWiki.

=head1 SUBROUTINES

=head2 C<obj2struct>

 my $struct_hr = obj2struct($obj);

Convert Wikidata::Datatype::Value::Quantity instance to structure.

Returns reference to hash with structure.

=head2 C<struct2obj>

 my $obj = struct2obj($struct_hr);

Convert structure of quantity to object.

Returns Wikidata::Datatype::Value::Quantity istance.

=head1 ERRORS

 obj2struct():
         Object isn't 'Wikidata::Datatype::Value::Quantity'.

 struct2obj():
         Structure isn't for 'quantity' datatype.

=head1 EXAMPLE1

 use strict;
 use warnings;

 use Data::Printer;
 use Wikidata::Datatype::Value::Quantity;
 use Wikidata::Datatype::Struct::Value::Quantity qw(obj2struct);

 # Object.
 my $obj = Wikidata::Datatype::Value::Quantity->new(
         'unit' => 'Q190900',
         'value' => 10,
 );

 # Get structure.
 my $struct_hr = obj2struct($obj, 'http://test.wikidata.org/entity/');

 # Dump to output.
 p $struct_hr;

 # Output:
 # \ {
 #     type    "quantity",
 #     value   {
 #         amount   "+10",
 #         unit     "http://test.wikidata.org/entity/Q190900"
 #     }
 # }

=head1 EXAMPLE2

 use strict;
 use warnings;

 use Data::Printer;
 use Wikidata::Datatype::Struct::Value::Quantity qw(struct2obj);

 # Quantity structure.
 my $struct_hr = {
         'type' => 'quantity',
         'value' => {
                 'amount' => '+10',
                 'unit' => 'http://test.wikidata.org/entity/Q190900',
         },
 };

 # Get object.
 my $obj = struct2obj($struct_hr);

 # Get type.
 my $type = $obj->type;

 # Get unit.
 my $unit = $obj->unit;

 # Get value.
 my $value = $obj->value;

 # Print out.
 print "Type: $type\n";
 if (defined $unit) {
         print "Unit: $unit\n";
 }
 print "Value: $value\n";

 # Output:
 # Type: quantity
 # Unit: Q190900
 # Value: 10

=head1 DEPENDENCIES

L<Error::Pure>,
L<Exporter>,
L<Readonly>,
L<URI>,
L<Wikidata::Datatype::Value::Property>.

=head1 SEE ALSO

=over

=item L<Wikidata::Datatype::Struct>

Wikidata structure serialization.

=item L<Wikidata::Datatype::Value::Quantity>

Wikidata quantity value datatype.

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
