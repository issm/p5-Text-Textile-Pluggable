package Text::Textile::Pluggable::Plugin::GitHub::Links;
use strict;
use warnings;

my $re_link = qr{\b(github:([\/\-\_\w]+))};

sub pre {
    my ($o, $text) = @_;
    #$text =~ s{$re_link}{"$1":https://github.com/$2}g;
    $text =~ s{$re_link}{<a href="https://github.com/$2">$1</a>}g;
    return $text;
}


1;
