use strict;
use warnings;
use Test::More;
use Test::Deep;

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

	my @expected = (
		re(q((?x)PPI::Document)),
		re(q((?x)  PPI::Statement)),
		re(q((?x)    PPI::Token::Magic          \s*   '\$_'        )),
		re(q((?x)    PPI::Token::Whitespace     \s*   '\ '         )),
		re(q((?x)    PPI::Token::Operator       \s*   '='          )),
		re(q((?x)    PPI::Token::Whitespace     \s*   '\ '         )),
		re(q((?x)    PPI::Token::Magic          \s*   '\$_'        )),
		re(q((?x)    PPI::Structure::Subscript  \s*   \[\ ...\ \]  )),
		re(q((?x)    PPI::Statement::Expression                    )),
		re(q((?x)        PPI::Token::Number     \s*   '2'          )),
	);

	#diag explain @out;
        cmp_deeply \@out, \@expected, "--ppidump $cmd";
}

