package Text::Textile::Pluggable::Plugin::OO::AppendPrepend;
use strict;
use base 'Text::Textile::Pluggable::Plugin::Base';

sub pre {
    my ($o, $text) = @_;
    return "foobar\n" . $text;
}

sub post {
    my ($o, $text) = @_;
    return $text . "\nfoobar";
}

1;
