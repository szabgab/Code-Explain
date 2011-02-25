use strict;
use warnings;
use Test::More;

my %cases = (
	'$_'         => 'Default variable',
	'@_'         => 'Default array',
	'given'      => 'keyword in perl 5.10',
	'say'        => 'keyword in perl 5.10',
	'say()'      => 'keyword in perl 5.10',
	'$_[1]'      => 'This is element 1 of the default array @_',
	'$name[$id]' => 'This is element $id of the array @name',
	'$$y'        => '$y is a reference to a scalar value. This expression dereferences it. See perlref',
	'1'          => 'A number',
	'23.14'      => 'A number',
	'12_345'     => 'This is the same as the number 12345 just in a more readable format',
	'1+1'        => 'Numerical operation',
	'1   +1'     => 'Numerical operation',
	'1   - 1'    => 'Numerical operation',
	'!!'         => 'Creating boolean context by negating the value on the right hand side twice',
);

my %todo = (
	'$x ||= $y'     => 'Assigning default value',
	'$phone{$name}' => 'The element $name of the hash %phone',
	'$x = /regex/'  => '$x = $_ =~ /regex/',
	q("print 'hey';") => '',
	q('string')     => '',
	'split()'       => '',
	q('' .)         => 'Forcing string context',
	q(0 +)          => 'Forcing numeric context',
);

plan tests => scalar(keys %cases) + scalar(keys %todo) + 1;

require Code::Explain;

my $ce = Code::Explain->new;
foreach my $str (sort keys %cases) {
	is $ce->explain($str), $cases{$str}, "<$str>";
}

foreach my $str (sort keys %todo) {
	TODO: {
		local $TODO = "$str is not yet handled";
		is $ce->explain($str), $todo{$str}, $str;
	}
}

{
	my @dump = $ce->ppi_dump('$_');
	#diag explain @dump;
	my @expected = (
		q(PPI::Document),
		q(  PPI::Statement),
		qq(    PPI::Token::Magic  \t'\$_'),   # why is that tab there?
	);
	is_deeply \@dump, \@expected, 'dump $_';
	#diag $dump[2] =~ s/\t/TAB/g;
}

