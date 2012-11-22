package My::Plugin::Foo;
use parent 'Text::Textile::Pluggable::Base';

sub pre {
    my ($self, $text) = @_;
    return defined $self->{foo} ? $self->{foo} : $text;
}

1;

package My::Plugin::Bar;
use parent 'Text::Textile::Pluggable::Base';

sub pre {
    my ($self, $text) = @_;
    return defined $self->{bar} ? $self->{bar} : $text;
}

1;


package main;
use strict;
use warnings;
use Test::More;
use Test::Flatten;
use Try::Tiny;
use t::Util;


subtest 'no parameter' => sub {
    my $ttp = new_object();
    is scalar( keys %{$ttp->{__plugin}} ), 0;
};


subtest 'parameter: plugin' => sub {
    my $ttp;

    $ttp = new_object( plugins => [qw/+My::Plugin::Foo/] );
    ok exists $ttp->{__plugin}{'My::Plugin::Foo'};
    is $ttp->textile('foobar'), '<p>foobar</p>';

    $ttp = new_object( plugins => [qw/+My::Plugin::Bar/] );
    is $ttp->textile('foobar'), '<p>foobar</p>';
};


subtest 'parameter: plugins, vars' => sub {
    subtest 'foo' => sub {
        my $ttp;

        $ttp = new_object(
            plugins => [qw/+My::Plugin::Foo/],
            vars    => { foo => 'foo' },
        );
        is $ttp->{__plugin}{'My::Plugin::Foo'}{foo}, 'foo';
        is $ttp->{__plugin}{'My::Plugin::Foo'}{bar}, undef;
        is $ttp->textile('foobar'), '<p>foo</p>';

        $ttp = new_object(
            plugins => [qw/+My::Plugin::Foo/],
            vars    => { bar => 'bar' },
        );
        is $ttp->{__plugin}{'My::Plugin::Foo'}{foo}, undef;
        is $ttp->{__plugin}{'My::Plugin::Foo'}{bar}, 'bar';
        is $ttp->textile('foobar'), '<p>foobar</p>';
    };

    subtest 'bar' => sub {
        my $ttp;

        $ttp = new_object(
            plugins => [qw/+My::Plugin::Bar/],
            vars    => { foo => 'foo' },
        );
        is $ttp->{__plugin}{'My::Plugin::Bar'}{foo}, 'foo';
        is $ttp->{__plugin}{'My::Plugin::Bar'}{bar}, undef;
        is $ttp->textile('foobar'), '<p>foobar</p>';

        $ttp = new_object(
            plugins => [qw/+My::Plugin::Bar/],
            vars    => { bar => 'bar' },
        );
        is $ttp->{__plugin}{'My::Plugin::Bar'}{foo}, undef;
        is $ttp->{__plugin}{'My::Plugin::Bar'}{bar}, 'bar';
        is $ttp->textile('foobar'), '<p>bar</p>';
    };

    subtest 'foo, bar' => sub {
        my $ttp;

        $ttp = new_object(
            plugins => [qw/+My::Plugin::Foo +My::Plugin::Bar/],
            vars    => { foo => 'foo', bar => 'bar' },
        );
        is $ttp->{__plugin}{'My::Plugin::Foo'}{foo}, 'foo';
        is $ttp->{__plugin}{'My::Plugin::Foo'}{bar}, 'bar';
        is $ttp->{__plugin}{'My::Plugin::Bar'}{foo}, 'foo';
        is $ttp->{__plugin}{'My::Plugin::Bar'}{bar}, 'bar';
        is $ttp->textile('foobar'), '<p>bar</p>';
    };
};

done_testing;
