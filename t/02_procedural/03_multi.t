use strict;
use warnings;
use Test::More;
use Test::Flatten;
use Text::Textile::Pluggable qw/textile/;
use t::Util;


subtest 'ordering "pre"' => sub {
    my $t0 = << '...';
"foobar":http://www.cpan.org/
...
    is textile($t0), '<p><a href="http://www.cpan.org/">foobar</a></p>';
    is textile($t0, [qw/P1 P2/]), '<p><a href="http://www.perl.org/">foobar</a></p>';
    is textile($t0, [qw/P2 P1/]), '<p><a href="http://www.plackperl.org/">foobar</a></p>';
};


subtest 'ordering of "post"' => sub {
    my $t0 = << '...';
foobar
...
    is textile($t0), '<p>foobar</p>';
    is textile($t0, [qw/P3 P4/]), '<p>foobar</p>hogefuga';
    is textile($t0, [qw/P4 P3/]), '<p>foobar</p>fugahoge';
};


subtest 'with vars' => sub {
    is textile( 'hoge', [qw/+My::Other::Plugin::Foo +My::Other::Plugin::Bar/] ), '<p>hogefoobar</p>foobar';
    is textile( 'hoge', [qw/+My::Other::Plugin::Foo +My::Other::Plugin::Bar/], { foo => 'foo' }), '<p>hogefoo</p>foobar';
    is textile( 'hoge', [qw/+My::Other::Plugin::Foo +My::Other::Plugin::Bar/], { bar => 'bar' }), '<p>hogefoobar</p>bar';
    is textile( 'hoge', [qw/+My::Other::Plugin::Foo +My::Other::Plugin::Bar/], { foo => 'foo', bar => 'bar' }), '<p>hogefoo</p>bar';
};


done_testing;
