use strict;
use warnings;
use Test::More;
use Test::Flatten;
use t::Util;
use Text::Textile::Pluggable;
use Text::Textile::Pluggable::Plugin::Base;

my $p = Text::Textile::Pluggable::Plugin::Base->new(
    _textile => Text::Textile::Pluggable->new,
);
ok $p->can('textile');
isa_ok $p->textile(), 'Text::Textile::Pluggable';

done_testing;
