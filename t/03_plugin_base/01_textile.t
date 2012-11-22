use strict;
use warnings;
use Test::More;
use Test::Flatten;
use t::Util;
use Text::Textile::Pluggable;
use Text::Textile::Pluggable::Base;

my $ttp = new_object();
my $p = Text::Textile::Pluggable::Base->new( _textile => $ttp );
ok $p->can('textile');
isa_ok $p->textile(), 'Text::Textile::Pluggable';

done_testing;
