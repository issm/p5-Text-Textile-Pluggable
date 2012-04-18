use strict;
use warnings;
use Test::More;
use Try::Tiny;
use t::Util;


subtest 'single plugin' => sub {
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


subtest 'multi plugins' => sub {
    my $t0 = 'foobar';
    is textile_($t0), '<p>foobar</p>';

    my $ttp = new_object(
        plugins => [qw/ Append Prepend /],
    );
    is $ttp->textile($t0), ( textile_("foobar\n" . $t0) . "\nfoobar" );
    is $ttp->process($t0), ( textile_("foobar\n" . $t0) . "\nfoobar" );
};


done_testing;
