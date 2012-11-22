package Text::Textile::Pluggable::OO::Prepend;
use strict;
use base 'Text::Textile::Pluggable::Base';

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
