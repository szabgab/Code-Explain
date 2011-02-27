use strict;
use warnings;
use Test::More;

plan tests => 1;

my $code = '$_ = $_[2]';

diag $^O;

my $deli = $^O =~ /MSWin/i ? '"' : "'";

my $out = qx{$^X -I lib script/explain-code $deli$code$deli};
chomp $out;
is ($out, 'This is element 2 of the default array @_', $code);
