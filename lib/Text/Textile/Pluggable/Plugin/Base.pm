package Text::Textile::Pluggable::Plugin::Base;
use 5.008001;
use strict;
use warnings;

sub new {
    my $class = shift;
    my %params = @_;
    my $self = bless \%params, $class;
    $self->init();
    return $self;
}

sub init {}

sub textile { shift->{_textile} }

sub pre { $_[1] }

sub post { $_[1] }

1;
