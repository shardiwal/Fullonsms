#!perl -T

use Test::More tests => 4;

BEGIN {
    use_ok( 'Fullonsms' ) || print "Bail out!\n";
    use_ok( 'Fullonsms::Session' ) || print "Bail out!\n";
    use_ok( 'Fullonsms::Message' ) || print "Bail out!\n";
    use_ok( 'Fullonsms::Util' ) || print "Bail out!\n";
}

diag( "Testing Fullonsms $Fullonsms::VERSION, Perl $], $^X" );
