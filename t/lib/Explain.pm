package t::lib::Explain;
use strict;
use warnings;

use Test::Deep;

our @cases = (
	{
		expected_ppidump => [
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
		],
	},
);

1;
