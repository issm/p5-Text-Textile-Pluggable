package Text::Textile::Pluggable::GitHub::Gist;
use strict;
use warnings;

my $re_link = qr{\bgist:(\d+)(?:\#(\S+))?};

sub pre {
    my ($o, $text) = @_;
    $text =~ s{$re_link}{
        my $src = sprintf('https://gist.github.com/%d.js', $1);
        $src .= "?file=$2"  if $2;
        qq{<script src="$src"></script>};
    }gex;
    return $text;
}

1;
