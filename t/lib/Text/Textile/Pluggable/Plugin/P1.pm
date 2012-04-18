package Text::Textile::Pluggable::Plugin::P1;
use strict;

sub pre {
    my ($o, $text) = @_;
    $text =~ s/cpan/perl/;
    return $text;
}

1;
