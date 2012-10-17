package Text::Textile::Pluggable;
use 5.008001;
use strict;
use warnings;
use parent 'Text::Textile';
use Text::Textile ();
use Class::Load ();

our $VERSION = '0.03';

sub import {
    my ($class, @subs) = @_;
    my $caller = caller;

    my $re_subs_can_import = qr/^(?:textile)$/;
    my @subs_import = grep /$re_subs_can_import/, @subs;

    for my $f (@subs_import) {
        no strict 'refs';
        *{"$caller\::$f"} = \&$f;
    }
}

sub new {
    my ($class, %params) = @_;
    my $self = bless Text::Textile->new(), $class;

    # additional properties;
    $self->{__plugin}  = +{};  # store only "objective" plugin
    $self->{__modules} = [];

    my $plugins = $params{plugins} || $params{plugin};
    $plugins ||= [];
    $plugins = [$plugins]  if ref($plugins) eq '';

    $self->load_plugins(@$plugins);

    return $self;
}

sub load_plugins {
    my ($self, @args) = @_;
    my $count = 0;
    # ref: Amon2::load_plugins
    while ( @args ) {
        my $module = shift @args;
        my $vars   = @args > 0 && ref($args[0]) eq 'HASH' ? (shift @args) : undef;
        $self->load_plugin($module, $vars);
        $count++;
    }
    return $count;
}

sub load_plugin {
    my ($self, $name, $vars) = @_;
    my $module = $name;
    my $prefix = __PACKAGE__ . '::Plugin::';
    if ( $module =~ /^\+/ ) {
        $module =~ s/^\+//;
    } else {
        $module = $prefix . $module;
    }
    Class::Load::load_class($module)  &&  (push @{$self->{__modules}}, $module);

    ### oop
    if ( $module->can('new') ) {
        $vars = +{}  unless ref($vars) eq 'HASH';
        my $p = $module->new( %$vars, _textile => $self );  # if $vars->{_texitle} exists, ignored!
        $self->{__plugin}{$name} = $self->{__plugin}{$module} = $p;
    }
    ### traditional
    else {
        if ( exists &{"$module\::init"} ) {
            no strict 'refs';
            *{"$module\::init"}->($self);
        }
    }

    return 1;
}

### override of Text::Textile
sub textile {
    my ($self, $text, $plugins);
    my $ret = '';

    ### oop
    if ( ref($_[0]) eq __PACKAGE__ ) {
        $self = shift;
        ($text, $plugins) = @_;
        $self->load_plugins(@$plugins)  if defined $plugins;
    }
    ### functional
    unless (defined $self) {
        ($text, $plugins) = @_;
        $self = __PACKAGE__->new( plugins => $plugins );
    }
    $ret = $text;
    $ret = ''  unless defined $ret;

    my @modules = @{$self->{__modules}};

    ### pre
    for my $m (@modules) {
        if ( exists $self->{__plugin}{$m} ) {
            $ret = $self->{__plugin}{$m}->pre($ret);
        }
        elsif ( exists &{"$m\::pre"} ) {
            no strict 'refs';
            $ret = *{"$m\::pre"}->($self, $ret);
        }
    }

    ### textile
    $ret = Text::Textile::textile($ret);

    ### post
    for my $m (@modules) {
        if ( exists $self->{__plugin}{$m} ) {
            $ret = $self->{__plugin}{$m}->post($ret);
        }
        elsif ( exists &{"$m\::post"} ) {
            no strict 'refs';
            $ret = *{"$m\::post"}->($self, $ret);
        }
    }

    return $ret;
}

1;
__END__

=head1 NAME

Text::Textile::Pluggable - Pluggable textile

=head1 SYNOPSIS

  use Text::Textile::Pluggable qw/textile/;

  # procedural usage
  my $html = textile($text, [qw/Foobar +MyApp::Textile::Plugin/]);

  # OOP usage
  my $textile = Text::Textile::Pluggable->new(
      plugins => [qw/Foobar +MyApp::Textile::Plugin/],
  );
  $html = $textile->process($text);

=head1 DESCRIPTION

Text::Textile::Pluggable is a subclass of Text::Textile and can load plugins that can process before and/or after processing "textiled" text.

=head1 HOW TO CREATE PLUGIN

You can create "plugin module" as follows:

  package Text::Textile::Pluggable::Plugin::Foobar;

  # before proceccing textiled text
  sub pre {
      my $textile = shift;
      my $text    = shift;  # text BEFORE processing
      ...
      return $text;
  }

  # after proceccing textiled text
  sub post {
      my $textile = shift;
      my $text    = shift;  # text AFTER processing
      ...
      return $text;
  }

  1;

Subroutine "pre" defines the processing BEFORE processing "textiled" text, and subroutine "post" defines the processing AFTER processing "textiled" text.

You don't need to follow "Text::Textile::Pluggable::Plugin::*" namespace:

  package MyApp::Textile::Plugin;

  ...

  1;

These plugins can be loaded in your script, as in SYNOPSYS.

=head1 CONSTRUCTOR

Prameters are available as follows:

=head2 $textile = Text::Textile::Pluggable->new(%params)

=over 4

=item plugins => \@plugins

Plugin module name(s) to load.

=back

=head1 METHODS

=head2 $textile->load_plugin($plugin)

Loads plugin.

=head2 $textile->load_plugins(@plugins)

Loads plugins.

=head2 $html = $textile->textile($text)

Basically, same as textile method in Text::Textile.

If plugins are already loaded, they are processed before and/or after processing $text.

=head2 $html = $textile->process($text)

Synonym of textile method.

=head1 AUTHOR

issm E<lt>issmxx@gmail.comE<gt>

=head1 SEE ALSO

L<Text::Textile>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
