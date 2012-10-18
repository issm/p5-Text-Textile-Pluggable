use strict;
use warnings;
use Test::More;
use Test::LeakTrace;
use t::Util;

no_leaks_ok {
    my $ttp = new_object();
    $ttp->textile('foobar');
};

no_leaks_ok {
    my $ttp;

    $ttp = new_object();
    $ttp->load_plugins(qw/Init P1 P2 P3 P4/);
    $ttp->textile('foobar');

    $ttp = new_object();
    $ttp->load_plugin( 'Init' => +{ foo => 'bar' } );
    $ttp->textile('foobar');
};

no_leaks_ok {
    my $ttp;

    $ttp = new_object();
    $ttp->load_plugins(qw/OO::1/);
    $ttp->textile('foobar');

    $ttp = new_object();
    $ttp->load_plugins(qw/OO::1 OO::2 OO::3/);
    $ttp->textile('foobar');
};


done_testing;
