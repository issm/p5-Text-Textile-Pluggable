use strict;
use warnings;
use Test::More;
use Test::Flatten;
use Text::Textile::Pluggable qw/textile/;
use t::Util;


my $text = << '...';
foo

* bar
...
is textile($text), textile_($text);

done_testing;
