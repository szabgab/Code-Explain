package Code::Explain::Perl5::Index;
use strict;
use warnings;


sub collect {
	my @index = $self->_collect_perldoc();


	# Return a unique sorted index
	my %seen = ();
	my @unique_sorted_index = sort grep { !$seen{$_}++ } @index;
	return \@unique_sorted_index;
}


sub _collect_perldoc {
	my $self = shift;

	my @index;

	# The categorization has been "borrowed" from
	# http://github.com/jonallen/perldoc.perl.org/tree
	# In lib/PerlDoc/Section.pm

	# Overview
	push @index, qw/perl perlintro perlrun perlbook perlcommunity/;

	# Tutorials
	push @index, qw/perlreftut perldsc perllol perlrequick
		perlretut perlboot perltoot perltooc perlbot
		perlstyle perlcheat perltrap perldebtut
		perlopentut perlpacktut perlthrtut perlothrtut
		perlxstut perlunitut perlpragma/;

	# FAQ
	push @index, qw/perlunifaq perlfaq1 perlfaq2 perlfaq3
		perlfaq4 perlfaq5 perlfaq6 perlfaq7 perlfaq8 perlfaq9/;

	# Language reference
	push @index, qw/perlsyn perldata perlsub perlop
		perlfunc perlpod perlpodspec perldiag
		perllexwarn perldebug perlvar perlre
		perlreref perlref perlform perlobj perltie
		perldbmfilter perlipc perlfork perlnumber
		perlport perllocale perluniintro perlunicode
		perlebcdic perlsec perlmod perlmodlib
		perlmodstyle perlmodinstall perlnewmod
		perlcompile perlfilter perlglossary CORE/;

	# Internals
	push @index, qw/perlembed perldebguts perlxs perlxstut
		perlclib perlguts perlcall perlapi perlintern
		perliol perlapio perlhack perlreguts perlreapi/;

	# History
	push @index, qw/perlhist perltodo perldelta/;

	# license
	push @index, qw/perlartistic perlgpl/;

	# Platform Specific
	push @index, qw/perlaix perlamiga perlapollo perlbeos perlbs2000
		perlce perlcygwin perldgux perldos perlepoc
		perlfreebsd perlhpux perlhurd perlirix perllinux
		perlmachten perlmacos perlmacosx perlmint perlmpeix
		perlnetware perlos2 perlos390 perlos400
		perlplan9 perlqnx perlsolaris perlsymbian perltru64 perluts
		perlvmesa perlvms perlvos perlwin32/;

	# Pragmas
	push @index, qw/attributes attrs autouse base bigint bignum
		bigrat blib bytes charnames constant diagnostics
		encoding feature fields filetest if integer less lib
		locale mro open ops overload re sigtrap sort strict
		subs threads threads::shared utf8 vars vmsish
		warnings warnings::register/;

	# Utilities
	push @index, qw/perlutil a2p c2ph config_data corelist cpan cpanp
		cpan2dist dprofpp enc2xs find2perl h2ph h2xs instmodsh
		libnetcfg perlbug perlcc piconv prove psed podchecker
		perldoc perlivp pod2html pod2latex pod2man pod2text
		pod2usage podselect pstruct ptar ptardiff s2p shasum
		splain xsubpp perlthanks/;

	# Perl Special Variables (compiled these from perlvar)
	push @index,
		(
		'$ARG', '$_', '$a', '$b', '$1', '$2', '$3', '$4', '$5', '$6', '$7', '$8', '$9', '$MATCH',
		'$&',  '${^MATCH}',     '$PREMATCH',         '$`', '${^PREMATCH}',          '$POSTMATCH',
		'$\'', '${^POSTMATCH}', '$LAST_PAREN_MATCH', '$+', '$LAST_SUBMATCH_RESULT', '$^N',
		'@LAST_MATCH_END',         '@+',  '%+', '$INPUT_LINE_NUMBER', '$NR', '$.',
		'$INPUT_RECORD_SEPARATOR', '$RS', '$/', '$OUTPUT_AUTOFLUSH',  '$|',  '$OUTPUT_FIELD_SEPARATOR',
		'$OFS', '$,',                   '$OUTPUT_RECORD_SEPARATOR', '$ORS', '$\\',                 '$LIST_SEPARATOR',
		'$"',   '$SUBSCRIPT_SEPARATOR', '$SUBSEP',                  '$;',   '$FORMAT_PAGE_NUMBER', '$%',
		'$FORMAT_LINES_PER_PAGE', '$=', '$FORMAT_LINES_LEFT', '$-', '@LAST_MATCH_START', '@-',
		'%-', '$FORMAT_NAME',           '$~',           '$FORMAT_TOP_NAME', '$^',     '$FORMAT_LINE_BREAK_CHARACTERS',
		'$:', '$FORMAT_FORMFEED',       '$^L',          '$ACCUMULATOR',     '$^A',    '$CHILD_ERROR',
		'$?', '${^CHILD_ERROR_NATIVE}', '${^ENCODING}', '$OS_ERROR',        '$ERRNO', '$!',
		'%OS_ERROR', '%ERRNO',              '%!',         '$EXTENDED_OS_ERROR', '$^E',            '$EVAL_ERROR',
		'$@',        '$PROCESS_ID',         '$PID',       '$$',                 '$REAL_USER_ID',  '$UID',
		'$<',        '$EFFECTIVE_USER_ID',  '$EUID',      '$>',                 '$REAL_GROUP_ID', '$GID',
		'$(',        '$EFFECTIVE_GROUP_ID', '$EGID',      '$)',                 '$PROGRAM_NAME',  '$0',
		'$[',        '$]',                  '$COMPILING', '$^C',                '$DEBUGGING',     '$^D',
		'${^RE_DEBUG_FLAGS}', '${^RE_TRIE_MAXBUF}', '$SYSTEM_FD_MAX', '$^F',     '$^H', '%^H',
		'$INPLACE_EDIT',      '$^I',                '$^M',            '$OSNAME', '$^O', '${^OPEN}',
		'$PERLDB',   '$^P', '$LAST_REGEXP_CODE_RESULT', '$^R',         '$EXCEPTIONS_BEING_CAUGHT', '$^S',
		'$BASETIME', '$^T', '${^TAINT}',                '${^UNICODE}', '${^UTF8CACHE}',            '${^UTF8LOCALE}',
		'$PERL_VERSION',    '$^V',  '$WARNING', '$^W',   '${^WARNING_BITS}', '${^WIN32_SLOPPY_STAT}',
		'$EXECUTABLE_NAME', '$^X',  'ARGV',     '$ARGV', '@ARGV',            'ARGVOUT',
		'@F',               '@INC', '@ARG',     '@_',    '%INC',             '%ENV',
		'$ENV{expr}',       '%SIG', '$SIG{expr}'
		);

	# Support given keyword
	push @index, ('given');

	# Add Perl functions (perlfunc)
	$Type{say}   = 1;
	$Type{state} = 1;
	$Type{break} = 1;
	push @index, keys %Type;

	return @index;
}

1;

