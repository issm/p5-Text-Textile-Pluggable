use strict;
use warnings;
use Test::More;
use Test::Flatten;
use Try::Tiny;
use t::Util;


subtest 'traditional, single plugin' => sub {
    my $t0 = 'foobar';
    is textile_($t0), '<p>foobar</p>';

    subtest 'pre' => sub {
        my $ttp = new_object(
            plugins => [qw/ Prepend /],
        );
        is $ttp->textile($t0), textile_("foobar\n" . $t0);
        is $ttp->process($t0), textile_("foobar\n" . $t0);
    };

    subtest 'post' => sub {
        my $ttp = new_object(
            plugins => [qw/ Append /],
        );
        is $ttp->textile($t0), "<p>foobar</p>\nfoobar";
        is $ttp->process($t0), "<p>foobar</p>\nfoobar";
    };

    subtest 'pre+post' => sub {
        my $ttp = new_object(
            plugins => [qw/ AppendPrepend /],
        );
        is $ttp->textile($t0), ( textile_("foobar\nfoobar") . "\nfoobar" );
        is $ttp->process($t0), ( textile_("foobar\nfoobar") . "\nfoobar" );
    };
};


subtest 'traditional, multi plugins' => sub {
    my $t0 = 'foobar';
    is textile_($t0), '<p>foobar</p>';

    my $ttp = new_object(
        plugins => [qw/ Append Prepend /],
    );
    is $ttp->textile($t0), ( textile_("foobar\n" . $t0) . "\nfoobar" );
    is $ttp->process($t0), ( textile_("foobar\n" . $t0) . "\nfoobar" );
};


subtest 'objective, single plugin' => sub {
    subtest 'without vars' => sub {
        my $t0 = 'foobar';
        is textile_($t0), '<p>foobar</p>';

        subtest 'pre' => sub {
            my $ttp = new_object(
                plugins => [qw/OO::Prepend/],
            );
            is $ttp->textile($t0), textile_("foobar\n" . $t0);
            is $ttp->process($t0), textile_("foobar\n" . $t0);
        };

        subtest 'post' => sub {
            my $ttp = new_object(
                plugins => [qw/OO::Append/],
            );
            is $ttp->textile($t0), "<p>foobar</p>\nfoobar";
            is $ttp->process($t0), "<p>foobar</p>\nfoobar";
        };

        subtest 'pre+post' => sub {
            my $ttp = new_object(
                plugins => [qw/OO::AppendPrepend/],
            );
            is $ttp->textile($t0), ( textile_("foobar\nfoobar") . "\nfoobar" );
            is $ttp->process($t0), ( textile_("foobar\nfoobar") . "\nfoobar" );
        };
    };

    subtest 'with vars' => sub {
        my $t0 = 'foobar';
        is textile_($t0), '<p>foobar</p>';

        subtest 'pre' => sub {
            my $ttp1 = new_object(
                plugins => [ 'OO::Prepend' => +{ hoge => 'aaa' } ],
            );
            my $ttp2 = new_object(
                plugins => [ 'OO::Prepend' => +{ hoge => 'bbb' } ],
            );
            is $ttp1->textile($t0), textile_("aaa:foobar\n" . $t0);
            is $ttp2->textile($t0), textile_("bbb:foobar\n" . $t0);
        };

        subtest 'post' => sub {
            my $ttp1 = new_object(
                plugins => [ 'OO::Append' => +{ fuga => 'ccc' } ],
            );
            my $ttp2 = new_object(
                plugins => [ 'OO::Append' => +{ fuga => 'ddd' } ],
            );
            is $ttp1->textile($t0), "<p>foobar</p>\nfoobar:ccc";
            is $ttp2->textile($t0), "<p>foobar</p>\nfoobar:ddd";
        };
    };

    subtest 'with vars as arg' => sub {
        subtest 'pre' => sub {
            my $ttp = new_object( plugins => [qw/+My::Other::Plugin::Foo/] );
            is $ttp->textile('hoge'), '<p>hogefoobar</p>';
            is $ttp->textile('hoge',  { foo => 'hoge' } ), '<p>hogehoge</p>';
            is $ttp->textile('hoge',  { bar => 'fuga' } ), '<p>hogefoobar</p>';
        };

        subtest 'post' => sub {
            package main;
            my $ttp = new_object( plugins => [qw/+My::Other::Plugin::Bar/] );
            is $ttp->textile('hoge'), '<p>hoge</p>foobar';
            is $ttp->textile('hoge', { foo => 'hoge' } ), '<p>hoge</p>foobar';
            is $ttp->textile('hoge', { bar => 'fuga' } ), '<p>hoge</p>fuga';
        };
    };
};


subtest 'objective, multi plugins' => sub {
    my $t0 = 'foobar';
    is textile_($t0), '<p>foobar</p>';

    subtest 'without vars' => sub {
        my $ttp = new_object(
            plugins => [qw/ OO::Append OO::Prepend /],
        );
        is $ttp->textile($t0), ( textile_("foobar\n" . $t0) . "\nfoobar" );
        is $ttp->process($t0), ( textile_("foobar\n" . $t0) . "\nfoobar" );
    };

    subtest 'with vars' => sub {
        my $ttp1 = new_object(
            plugins => [
                'OO::Prepend' => +{ hoge => 'aaa' },
                'OO::Append'  => +{ fuga => 'bbb' },
            ],
        );
        my $ttp2 = new_object(
            plugins => [
                'OO::Prepend' => +{ hoge => 'ccc' },
                'OO::Append'  => +{ fuga => 'ddd' },
            ],
        );
        my $ttp3 = new_object(
            plugins => [
                'OO::Prepend' => +{ hoge => 'eee' },
                'OO::Append'  => +{ hoge => 'fff' },
            ],
        );
        my $ttp4 = new_object(
            plugins => [
                'OO::Prepend' => +{ fuga => 'ggg' },
                'OO::Append'  => +{ fuga => 'hhh' },
            ],
        );

        is $ttp1->textile($t0), ( textile_("aaa:foobar\n" . $t0) . "\nfoobar:bbb" );
        is $ttp2->textile($t0), ( textile_("ccc:foobar\n" . $t0) . "\nfoobar:ddd" );
        is $ttp3->textile($t0), ( textile_("eee:foobar\n" . $t0) . "\nfoobar" );
        is $ttp4->textile($t0), ( textile_("foobar\n" . $t0) . "\nfoobar:hhh" );
    };
};


done_testing;
