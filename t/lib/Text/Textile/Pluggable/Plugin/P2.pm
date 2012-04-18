package Text::Textile::Pluggable::Plugin::P2;
use strict;

sub pre {
    my ($o, $text) = @_;
    $text =~ s/cpan/plackperl/;
    return $text;
}

1;
