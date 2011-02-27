use strict;
use warnings;
use Test::More;
use Test::Deep;

use t::lib::Explain;

plan tests => 2;

my $code = '$_ = $_[2]';

diag $^O;

my $deli = $^O =~ /MSWin/i ? '"' : "'";

my $cmd = qq($^X -I lib script/explain-code $deli$code$deli);

{
	my $out = qx{$cmd};
	chomp $out;
	is ($out, 'This is element 2 of the default array @_', $code);
}

{
	my @out = qx{$cmd --ppidump};
	chomp @out;
	
	#diag explain @out;
        cmp_deeply \@out, $t::lib::Explain::cases[0]{expected_ppidump}, "--ppidump $cmd";
}

