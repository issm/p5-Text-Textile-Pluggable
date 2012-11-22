package Text::Textile::Pluggable::Init;
use strict;

sub init {
    my ($o, $vars) = @_;
    $vars ||= +{};
    $o->{foobarbaz} = exists $vars->{foobarbaz} ? $vars->{foobarbaz} : 'foobarbaz';
}

1;
