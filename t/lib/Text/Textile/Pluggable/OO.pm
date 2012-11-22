package Text::Textile::Pluggable::OO;
use strict;
use base 'Text::Textile::Pluggable::Base';

sub init {
    my $self = shift;
    $self->{hoge} = 'hogehoge';
}

1;
