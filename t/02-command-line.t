use strict;
use warnings;
use Test::More;
use Test::Deep;

use t::lib::Explain;

plan tests => 7;

my $code = $t::lib::Explain::cases[0]{code};

diag $^O;

my $quotes = $^O =~ /MSWin/i ? '"' : "'";

my $cmd = qq($^X -I lib script/explain-code $quotes$code$quotes);

{
	my $out = qx{$cmd --explain};
	like $out, qr{^Explain:\nThis is element 2 of the default array \@_\s*$}, $code;
}

{
	my @out = qx{$cmd --ppidump};
	chomp @out;
	is shift @out, 'PPI Dump:';
	is pop @out, '';
	
	#diag explain @out;
    cmp_deeply \@out, $t::lib::Explain::cases[0]{expected_ppidump}, "--ppidump $cmd";
}

{
	my @out = qx{$cmd --ppiexplain};
	chomp @out;
	is shift @out, 'PPI Explain:';
	is pop @out, '';

	#diag explain @out;
        cmp_deeply \@out, $t::lib::Explain::cases[0]{expected_ppiexplain}, "--ppiexplain $cmd";
}
