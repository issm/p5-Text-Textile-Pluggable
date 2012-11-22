package Text::Textile::Pluggable::AppendPrepend;
use strict;

sub pre {
    my ($o, $text) = @_;
    return "foobar\n" . $text;
}

sub post {
    my ($o, $text) = @_;
    return $text . "\nfoobar";
}

1;
