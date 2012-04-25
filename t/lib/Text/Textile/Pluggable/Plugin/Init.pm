package Text::Textile::Pluggable::Plugin::Init;
use strict;

sub init {
    my ($o) = @_;
    $o->{foobarbaz} = 'foobarbaz';
}

1;
