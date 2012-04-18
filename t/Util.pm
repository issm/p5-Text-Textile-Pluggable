package t::Util;
use strict;
use warnings;
use utf8;
use Text::Textile ();
use Text::Textile::Pluggable;

sub import {
    my @subs = qw/
        new_object
        textile_
    /;

    my $caller = caller;

    for my $f (@subs) {
        no strict 'refs';
        *{"$caller\::$f"} = \&$f;
    }
}

sub new_object {
    return Text::Textile::Pluggable->new(@_);
}

sub textile_ {
    return Text::Textile::textile(@_);
}

1;
