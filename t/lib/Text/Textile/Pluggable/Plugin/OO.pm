package Text::Textile::Pluggable::Plugin::OO;
use strict;
use base 'Text::Textile::Pluggable::Plugin::Base';

sub init {
    my $self = shift;
    $self->{hoge} = 'hogehoge';
}

1;
