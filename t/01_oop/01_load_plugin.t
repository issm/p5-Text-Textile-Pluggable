use strict;
use warnings;
use Test::More;
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
        my $ttp = new_object();
        ok ! exists $ttp->{foobarbaz};

        $ttp->load_plugin('Init');
        ok exists $ttp->{foobarbaz};
        is $ttp->{foobarbaz}, 'foobarbaz';

        ok ! exists new_object()->{foobarbaz};
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


done_testing;
