use strict;
use warnings;
use Test::More;
use Test::Flatten;
use Test::Differences;
use Text::Textile::Pluggable qw/textile/;
use t::Util;


subtest 'user, repository' => sub {
    my $textile = Text::Textile::Pluggable->new(
        plugins => [qw/ GitHub::Links /],
    );

    subtest 'simple' => sub {
        eq_or_diff (
            $textile->textile( 'github:issm' ),
            '<p><a href="https://github.com/issm">github:issm</a></p>',
        );

        eq_or_diff (
            $textile->textile( 'github:issm/p5-Text-Textile-Pluggable' ),
            '<p><a href="https://github.com/issm/p5-Text-Textile-Pluggable">github:issm/p5-Text-Textile-Pluggable</a></p>',
        );
    };

    subtest 'complicated' => sub {
        eq_or_diff (
            $textile->textile( << '...' ) . "\n",
foo github:issm bar
*hoge* github:nagoyapm -fuga-

foo github:issm/p5-Text-Textile-Pluggable bar
...
            << '...',
<p>foo <a href="https://github.com/issm">github:issm</a> bar<br />
<strong>hoge</strong> <a href="https://github.com/nagoyapm">github:nagoyapm</a> <del>fuga</del></p>

<p>foo <a href="https://github.com/issm/p5-Text-Textile-Pluggable">github:issm/p5-Text-Textile-Pluggable</a> bar</p>
...
        );
    };
};


done_testing;
