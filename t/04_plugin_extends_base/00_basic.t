package MyTextilePlugin::Foo;
use parent 'Text::Textile::Pluggable::Base';

sub init {
    my $self = shift;
    $self->{foo} = 'foofoo';
}

1;


package main;
use strict;
use warnings;
use Test::More;
use Test::Flatten;
use t::Util;
use Text::Textile::Pluggable::Base;

my ($p0, $p1);
$p0 = Text::Textile::Pluggable::Base->new;
$p1 = MyTextilePlugin::Foo->new;

ok ! exists $p0->{foo};
is $p1->{foo}, 'foofoo';

done_testing;
