package Code::Explain;
use 5.008;
use Moose;

our $VERSION = '0.01';

sub explain {
	my ($self, $code) = @_;

	# TODO we will maintain a database of exact matches
	my %exact = (
		'$_'    => 'Default variable',
		'@_'    => 'Default array',
		'given' => 'keyword in perl 5.10',
		'say'   => 'keyword in perl 5.10',
	);

	if ($exact{$code}) {
		return $exact{$code};
	}

	# say()
	if ($code =~ /^(\w+)\(\)$/) {
		my $sub = $1;
		if ($exact{$sub}) {
			return $exact{$sub};
		}
	}
	
	if ($code =~ /^\d+$/) {
		return 'A number';
	}

	if ($code =~ /^\d+(_\d\d\d)+$/) {
		return 'This is the same as the number ' . eval($code) . ' just in a more readable format';
	}

	# some special cases
	# $_[2], $_[$var], $name[42]
	if ($code =~ /\$(\w+)\[(.*?)\]/) {
		if ($1 eq '_') {
			return "This is element $2 of the default array \@_";
		} else {
			return "This is element $2 of the array \@$1";
		}
	}
	if ($code =~/^\$\$(\w+)$/) {
		return "\$$1 is a reference to a scalar value. This expression dereferences it. See perlref";
	}

	#require PPI::Document;
	#my $Document = PPI::Document->new($code);

	return "Not found";
}

sub ppi_dump {
	my ($self, $code) = @_;
	require PPI::Document;
	require PPI::Dumper;
	my $Document = PPI::Document->new(\$code);
	my $Dumper = PPI::Dumper->new( $Document );
	return $Dumper->list;
}



1;

