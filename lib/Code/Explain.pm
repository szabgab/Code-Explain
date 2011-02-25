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

	# parentheses after the name of a subroutine
	if ($code =~ /^(\w+)\(\)$/) {
		my $sub = $1;
		if ($exact{$sub}) {
			return $exact{$sub};
		}
	}

	my $NUMBER = qr{\d+(?:\.\d+)?};

	if ($code =~ m{^$NUMBER \s* [/*+-]  \s* $NUMBER$}x) {
		return 'Numerical operation';
	}

	# 2
	# 2.34
	if ($code =~ /^$NUMBER$/) {
		return 'A number';
	}

	# 23_145
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

