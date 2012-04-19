use strict;
use warnings;
use Test::More;
use Test::Differences;
use Text::Textile::Pluggable qw/textile/;
use t::Util;


subtest 'gist' => sub {
    my $textile = Text::Textile::Pluggable->new(
        plugins => [qw/ GitHub::Gist /],
    );

    subtest 'simple' => sub {
        eq_or_diff (
            $textile->textile( 'gist:123456' ),
            '<script src="https://gist.github.com/123456.js"></script>',
        );

        eq_or_diff (
            $textile->textile( 'gist:123456#file1' ),
            '<script src="https://gist.github.com/123456.js?file=file1"></script>',
        );
    };
};


done_testing;
