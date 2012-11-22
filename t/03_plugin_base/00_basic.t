use strict;
use warnings;
use Test::More;
use Test::Flatten;
use t::Util;
use Text::Textile::Pluggable::Base;

subtest 'no parameter' => sub {
    my $p = Text::Textile::Pluggable::Base->new;
    isa_ok $p, 'Text::Textile::Pluggable::Base';
    ok $p->can('init');
    ok $p->can('pre');
    ok $p->can('post');
};

subtest 'any parameter' => sub {
    my $p = Text::Textile::Pluggable::Base->new(
        foo => 'foofoo',
        bar => 'barbar',
    );
    isa_ok $p, 'Text::Textile::Pluggable::Base';
    is $p->{foo}, 'foofoo';
    is $p->{bar}, 'barbar';
};

done_testing;
