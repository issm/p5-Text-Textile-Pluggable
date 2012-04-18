use strict;
use warnings;
use Test::More;
use Text::Textile::Pluggable;
use t::Util;

my $ttp = new_object();
isa_ok $ttp, 'Text::Textile::Pluggable';
isa_ok $ttp->{plugins}, 'ARRAY';
isa_ok $ttp->{__modules}, 'ARRAY';
ok $ttp->can('textile'), 'can call method "textile"';
ok $ttp->can('process'), 'can call method "process"';

done_testing;
