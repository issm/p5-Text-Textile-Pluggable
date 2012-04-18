package Text::Textile::Pluggable::Plugin::Append;
use strict;

sub post {
    my ($o, $text) = @_;
    return $text . "\nfoobar";
}

1;
