use strict;
use warnings;
use Test::More;
use Test::Flatten;
use Try::Tiny;
use t::Util;


subtest 'named "Text::Textile::Pluggable::Plugin::*"' => sub {
    subtest 'good' => sub {
        my $ttp = new_object();
        try {
            is $ttp->load_plugin('P1'), 1;
            is $ttp->load_plugin('P2'), 1;
            is $ttp->{__modules}[0], 'Text::Textile::Pluggable::Plugin::P1';
            is $ttp->{__modules}[1], 'Text::Textile::Pluggable::Plugin::P2';
        } catch {
            my $msg = shift;
            fail 'Should succeed: ' . $msg;
        };
    };

    subtest 'good, with "init"' => sub {
        subtest 'without vars' => sub {
            my $ttp = new_object();
            ok ! exists $ttp->{foobarbaz};

            $ttp->load_plugin('Init');
            ok exists $ttp->{foobarbaz};
            is $ttp->{foobarbaz}, 'foobarbaz';

            ok ! exists new_object()->{foobarbaz};
        };

        subtest 'with vars' => sub {
            my $ttp;

            $ttp = new_object();
            ok ! exists $ttp->{foobarbaz};
            $ttp->load_plugin('Init', { foobarbaz => 'aaabbbccc' });
            ok exists $ttp->{foobarbaz};
            is $ttp->{foobarbaz}, 'aaabbbccc';

            $ttp = new_object();
            ok ! exists $ttp->{foobarbaz};
            $ttp->load_plugin('Init', { foobarbaz => 'dddeeefff' });
            ok exists $ttp->{foobarbaz};
            is $ttp->{foobarbaz}, 'dddeeefff';

            $ttp = new_object();
            ok ! exists $ttp->{foobarbaz};
            $ttp->load_plugin('Init', { foo => 'hoge' });
            ok exists $ttp->{foobarbaz};
            is $ttp->{foobarbaz}, 'foobarbaz';
        };
    };

    subtest 'bad' => sub {
        my $ttp = new_object();
        try {
            $ttp->load_plugin(qw/ PluginDoesNotExist /);
            fail 'Should have error';
        } catch {
            my $msg = shift;
            like $msg, qr{Can't locate Text/Textile/Pluggable/Plugin/PluginDoesNotExist\.pm};
        };
    };
};

subtest 'other module' => sub {
    subtest 'good' => sub {
        my $ttp = new_object();
        try {
            is $ttp->load_plugin('+My::Other::Plugin::Foobar'), 1;
            is $ttp->{__modules}[0], 'My::Other::Plugin::Foobar';
        } catch {
            my $msg = shift;
            fail 'Should succeed: ' . $msg;
        };
    };

    subtest 'bad' => sub {
        my $ttp = new_object();
        try {
            $ttp->load_plugin('+My::Other::Plugin::PluginDoesNotExist');
            fail 'Should have error';
        } catch {
            my $msg = shift;
            like $msg, qr{Can't locate My/Other/Plugin/PluginDoesNotExist.pm};
        };
    };
};

subtest 'mixed' => sub {
    subtest 'order 1' => sub {
        my $ttp = new_object();
        $ttp->load_plugin('P1');
        $ttp->load_plugin('+My::Other::Plugin::Foobar');
        is_deeply $ttp->{__modules}, [
            'Text::Textile::Pluggable::Plugin::P1',
            'My::Other::Plugin::Foobar',
        ];
    };

    subtest 'order 2' => sub {
        my $ttp = new_object();
        $ttp->load_plugin('+My::Other::Plugin::Foobar');
        $ttp->load_plugin('P1');
        is_deeply $ttp->{__modules}, [
            'My::Other::Plugin::Foobar',
            'Text::Textile::Pluggable::Plugin::P1',
        ];
    };
};


subtest 'objective plugin' => sub {
    subtest 'load "Base" plugin, without vars' => sub {
        my $ttp = new_object();
        $ttp->load_plugin('Base');

        my $p = $ttp->{__plugin}{'Base'};
        isa_ok $p, 'Text::Textile::Pluggable::Plugin::Base';
    };

    subtest 'load "Base" plugin, with vars' => sub {
        my $ttp = new_object();
        $ttp->load_plugin(
            'Base',
            +{ foo => 'foofoo', bar => 'barbar' },
        );
        my $p = $ttp->{__plugin}{'Base'};
        isa_ok $p->textile, 'Text::Textile::Pluggable';
    };

    subtest 'load "Base" plugin, with vars, key named "_textile"' => sub {
        my $ttp = new_object();
        $ttp->load_plugin(
            'Base',
            +{ _textile => '', foo => 'foofoo' },
        );
        my $p = $ttp->{__plugin}{'Base'};
        isa_ok $p->textile, 'Text::Textile::Pluggable';
    };


    subtest 'load "OO" plugin, without vars' => sub {
        my $ttp = new_object();
        $ttp->load_plugin('OO');
        my $p = $ttp->{__plugin}{'OO'};
        isa_ok $p, 'Text::Textile::Pluggable::Plugin::OO';
        is $p->{hoge}, 'hogehoge';
    };

    subtest 'load "OO" plugin, with vars' => sub {
        my $ttp = new_object();
        $ttp->load_plugin(
            'OO',
            +{ foo => 'foofoo', bar => 'barbar' },
        );
        my $p = $ttp->{__plugin}{'OO'};
        isa_ok $p, 'Text::Textile::Pluggable::Plugin::OO';
        is $p->{hoge}, 'hogehoge';
        is $p->{foo}, 'foofoo';
        is $p->{bar}, 'barbar';
    };
};


done_testing;
