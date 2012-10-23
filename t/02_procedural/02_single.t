use strict;
use warnings;
use Test::More;
use Test::Flatten;
use Text::Textile::Pluggable qw/textile/;
use t::Util;

subtest 'without vars' => sub {
    my $t0 = << '    ...';
foo

* bar
    ...
    my $t1 = "foobar\n" . $t0;

    is textile($t0, [qw/Prepend/]), textile_($t1);
    is textile($t0, [qw/Append/]), textile_($t0) . "\nfoobar";
    is textile($t0, [qw/AppendPrepend/]), ( textile_($t1) . "\nfoobar" );
    is textile($t0, [qw/+My::Other::Plugin::Foobar/]), ( textile_($t0) . "hogepiyo" );
};


subtest 'with vars' => sub {
    is textile( 'hoge', [qw/+My::Other::Plugin::Foo/] ), '<p>hogefoobar</p>';
    is textile( 'hoge', [qw/+My::Other::Plugin::Foo/], { foo => 'hoge' } ), '<p>hogehoge</p>';
    is textile( 'hoge', [qw/+My::Other::Plugin::Foo/], { bar => 'fuga' } ), '<p>hogefoobar</p>';

    is textile( 'hoge', [qw/+My::Other::Plugin::Bar/] ), '<p>hoge</p>foobar';
    is textile( 'hoge', [qw/+My::Other::Plugin::Bar/], { foo => 'hoge' } ), '<p>hoge</p>foobar';
    is textile( 'hoge', [qw/+My::Other::Plugin::Bar/], { bar => 'fuga' } ), '<p>hoge</p>fuga';
};

done_testing;
