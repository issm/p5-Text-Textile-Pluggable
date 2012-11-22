package Text::Textile::Pluggable::Base;
use 5.008001;
use strict;
use warnings;
use Scalar::Util ();

sub new {
    my $class = shift;
    my %params = @_;
    my $self = bless \%params, $class;
    Scalar::Util::weaken( $self->{_textile} );
    $self->init();
    return $self;
}

sub init {}

sub textile { shift->{_textile} }

sub pre { $_[1] }

sub post { $_[1] }

1;
