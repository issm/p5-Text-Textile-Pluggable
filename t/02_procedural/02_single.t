use strict;
use warnings;
use Test::More;
use Test::Flatten;
use Text::Textile::Pluggable qw/textile/;
use t::Util;

my $t0 = << '...';
foo

* bar
...
my $t1 = "foobar\n" . $t0;

is textile($t0, [qw/Prepend/]), textile_($t1);
is textile($t0, [qw/Append/]), textile_($t0) . "\nfoobar";
is textile($t0, [qw/AppendPrepend/]), ( textile_($t1) . "\nfoobar" );
is textile($t0, [qw/+My::Other::Plugin::Foobar/]), ( textile_($t0) . "hogepiyo" );

done_testing;
