package Text::Textile::Pluggable::Plugin::Prepend;
use strict;

sub pre {
    my ($o, $text) = @_;
    return "foobar\n" . $text;
}

1;
