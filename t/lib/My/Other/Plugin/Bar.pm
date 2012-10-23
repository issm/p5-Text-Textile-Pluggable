package My::Other::Plugin::Bar;
use strict;

sub post {
    my ($self, $text, $vars) = @_;
    return $text . ( defined $vars->{bar} ? $vars->{bar} : 'foobar' );
}

1;
