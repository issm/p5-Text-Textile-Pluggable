use strict;
use warnings;
use Test::More;
use Test::Flatten;
use Try::Tiny;
use t::Util;


subtest 'named "Text::Textile::Pluggable::Plugin::*"' => sub {
    subtest 'good' => sub {
        my $ttp1 = new_object();
        my $ttp2 = new_object();
        try {
            isa_ok $ttp1->load_plugin('P1'), 'Text::Textile::Pluggable';
            isa_ok $ttp1->load_plugin('P2'), 'Text::Textile::Pluggable';
            is $ttp1->{__modules}[0], 'Text::Textile::Pluggable::P1';
            is $ttp1->{__modules}[1], 'Text::Textile::Pluggable::P2';
            isa_ok $ttp2->load_plugin('P1')->load_plugin('P2'), 'Text::Textile::Pluggable';
            is_deeply $ttp1->{__modules}, $ttp2->{__modules};
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
            like $msg, qr{Can't locate Text/Textile/Pluggable/PluginDoesNotExist\.pm};
        };
    };
};

subtest 'other module' => sub {
    subtest 'good' => sub {
        my $ttp = new_object();
        try {
            isa_ok $ttp->load_plugin('+My::Other::Plugin::Foobar'), 'Text::Textile::Pluggable';
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
            'Text::Textile::Pluggable::P1',
            'My::Other::Plugin::Foobar',
        ];
    };

    subtest 'order 2' => sub {
        my $ttp = new_object();
        $ttp->load_plugin('+My::Other::Plugin::Foobar');
        $ttp->load_plugin('P1');
        is_deeply $ttp->{__modules}, [
            'My::Other::Plugin::Foobar',
            'Text::Textile::Pluggable::P1',
        ];
    };
};


subtest 'objective plugin' => sub {
    subtest 'load "Base" plugin, without vars' => sub {
        my $ttp = new_object();
        $ttp->load_plugin('Base');

        my $p = $ttp->{__plugin}{'Base'};
        isa_ok $p, 'Text::Textile::Pluggable::Base';
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
        isa_ok $p, 'Text::Textile::Pluggable::OO';
        is $p->{hoge}, 'hogehoge';
    };

    subtest 'load "OO" plugin, with vars' => sub {
        my $ttp = new_object();
        $ttp->load_plugin(
            'OO',
            +{ foo => 'foofoo', bar => 'barbar' },
        );
        my $p = $ttp->{__plugin}{'OO'};
        isa_ok $p, 'Text::Textile::Pluggable::OO';
        is $p->{hoge}, 'hogehoge';
        is $p->{foo}, 'foofoo';
        is $p->{bar}, 'barbar';
    };
};


done_testing;
