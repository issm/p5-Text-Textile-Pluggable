package My::Other::Plugin::Foo;
use strict;

sub pre {
    my ($self, $text, $vars) = @_;
    return $text . ( defined $vars->{foo} ? $vars->{foo} : 'foobar' );
}

1;
