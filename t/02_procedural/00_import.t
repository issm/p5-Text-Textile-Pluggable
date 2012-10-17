use strict;
use warnings;
use Test::More;
use Test::Flatten;
use Try::Tiny;
use Text::Textile::Pluggable qw/
    import
    new
    load_plugins
    load_plugin
    textile
/;
use t::Util;


subtest 'can\'t call' => sub {
    subtest 'import' => sub {
        try {
            import();
            fail 'Shoud have error';
        } catch {
            my $msg = shift;
            like $msg, qr/Undefined subroutine \&main::import/;
        };
    };

    subtest 'new' => sub {
        try {
            new();
            fail 'Shoud have error';
        } catch {
            my $msg = shift;
            like $msg, qr/Undefined subroutine \&main::new/;
        };
    };

    subtest 'load_plugins' => sub {
        try {
            load_plugins();
            fail 'Shoud have error';
        } catch {
            my $msg = shift;
            like $msg, qr/Undefined subroutine \&main::load_plugins/;
        };
    };

    subtest 'load_plugin' => sub {
        try {
            load_plugin();
            fail 'Shoud have error';
        } catch {
            my $msg = shift;
            like $msg, qr/Undefined subroutine \&main::load_plugin/;
        };
    };
};


subtest 'can call' => sub {
    subtest 'textile' => sub {
        try {
            textile();
            ok 'Can call subroutine 6main::textile';
        } catch {
            my $msg = shift;
            fail 'Shoud succeed: ' . $msg;
        };
    };
};


done_testing;
