package Text::Textile::Pluggable::Plugin::OO::Append;
use strict;
use base 'Text::Textile::Pluggable::Plugin::Base';

sub post {
    my ($self, $text) = @_;
    if ( exists $self->{fuga} ) {
        return $text . "\nfoobar:" . $self->{fuga};
    }
    else {
        return $text . "\nfoobar";
    }
}

1;
