package Text::Textile::Pluggable::OO::Append;
use strict;
use base 'Text::Textile::Pluggable::Base';

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
