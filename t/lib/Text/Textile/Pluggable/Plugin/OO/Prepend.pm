package Text::Textile::Pluggable::Plugin::OO::Prepend;
use strict;
use base 'Text::Textile::Pluggable::Plugin::Base';

sub pre {
    my ($self, $text) = @_;
    if ( exists $self->{hoge} ) {
        return $self->{hoge} . ":foobar\n" . $text;
    }
    else {
        return "foobar\n" . $text;
    }
}

1;
