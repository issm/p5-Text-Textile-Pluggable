use strict;
use warnings;
use Test::More;
use Test::Flatten;
use Try::Tiny;
use t::Util;


subtest 'good, traditional' => sub {
    my $ttp = new_object();

    is $ttp->load_plugins(qw/
        P1
        P2
        +My::Other::Plugin::Foobar
    /), 3;

    is_deeply $ttp->{__modules}, [qw/
        Text::Textile::Pluggable::Plugin::P1
        Text::Textile::Pluggable::Plugin::P2
        My::Other::Plugin::Foobar
    /];

    is $ttp->load_plugins(qw/
        P3
        P4
    /), 2;

    is_deeply $ttp->{__modules}, [qw/
        Text::Textile::Pluggable::Plugin::P1
        Text::Textile::Pluggable::Plugin::P2
        My::Other::Plugin::Foobar
        Text::Textile::Pluggable::Plugin::P3
        Text::Textile::Pluggable::Plugin::P4
    /];
};


subtest 'bad' => sub {
    my $ttp = new_object();

    try {
        $ttp->load_plugins(qw/
            P1
            P2
            PluginDoesNotExist
        /);
        fail 'Shoud have error';
    } catch {
        my $msg = shift;
        like $msg, qr{Can't locate Text/Textile/Pluggable/Plugin/PluginDoesNotExist.pm};
    };
};


subtest 'good, objective' => sub {
    subtest 'without vars' => sub {
        my $ttp = new_object();
        is $ttp->load_plugins(qw/
            OO::1
            OO::3
            OO::2
        /), 3;

        is_deeply $ttp->{__modules}, [qw/
            Text::Textile::Pluggable::Plugin::OO::1
            Text::Textile::Pluggable::Plugin::OO::3
            Text::Textile::Pluggable::Plugin::OO::2
        /];

        isa_ok $ttp->{__plugin}{'OO::1'}->textile, 'Text::Textile::Pluggable';
        isa_ok $ttp->{__plugin}{'OO::2'}->textile, 'Text::Textile::Pluggable';
        isa_ok $ttp->{__plugin}{'OO::3'}->textile, 'Text::Textile::Pluggable';
    };

    # ref: https://github.com/tokuhirom/Amon/blob/master/t/100_core/014_load_plugins.t
    subtest 'with vars' => sub {
        my $ttp = new_object();
        is $ttp->load_plugins(
            'OO::1',
            'OO::2' => +{ foo => 'foofoo' },
            'OO::3',
        ), 3;

        is_deeply $ttp->{__modules}, [qw/
            Text::Textile::Pluggable::Plugin::OO::1
            Text::Textile::Pluggable::Plugin::OO::2
            Text::Textile::Pluggable::Plugin::OO::3
        /];

        my ($p1, $p2, $p3) = @{$ttp->{__plugin}}{qw/OO::1 OO::2 OO::3/};
        isa_ok $p1->textile, 'Text::Textile::Pluggable';
        isa_ok $p2->textile, 'Text::Textile::Pluggable';
        isa_ok $p3->textile, 'Text::Textile::Pluggable';
        ok ! exists $p1->{foo};
        is $p2->{foo}, 'foofoo';
        ok ! exists $p3->{foo};
    };
};


done_testing;
