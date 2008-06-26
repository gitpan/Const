#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Const' );
}

diag( "Testing Const $Const::VERSION, Perl $], $^X" );
