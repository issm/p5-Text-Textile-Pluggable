package Text::Textile::Pluggable::OO::AppendPrepend;
use strict;
use base 'Text::Textile::Pluggable::Base';

sub pre {
    my ($o, $text) = @_;
    return "foobar\n" . $text;
}

sub post {
    my ($o, $text) = @_;
    return $text . "\nfoobar";
}

1;
