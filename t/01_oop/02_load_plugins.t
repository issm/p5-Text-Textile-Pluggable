use strict;
use warnings;
use Test::More;
use Try::Tiny;
use t::Util;


subtest 'good' => sub {
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


done_testing;
