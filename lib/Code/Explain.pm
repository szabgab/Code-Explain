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

	# some special cases
	# $_[2], $_[$var], $name[42]
	if ($code =~ /\$(\w+)\[(.*?)\]/) {
		if ($1 eq '_') {
			return "This is element $2 of the default array \@_";
		} else {
			return "This is element $2 of the array \@$1";
		}
	}

	#require PPI::Document;
	#my $Document = PPI::Document->new($code);

	return "Not found";
}




1;

