package Text::Textile::Pluggable::P2;
use strict;

sub pre {
    my ($o, $text) = @_;
    $text =~ s/cpan/plackperl/;
    return $text;
}

1;
