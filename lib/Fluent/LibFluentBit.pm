package Fluent::LibFluentBit;
use strict;
use warnings;
use Carp;
use JSON::MaybeXS;

# VERSION
# ABSTRACT: Perl interface to libfluent-bit.so

require XSLoader;
XSLoader::load('Fluent::LibFluentBit', $Fluent::LibFluentBit::VERSION);

my $default_instance;
sub default_instance {
   $default_instance //= Fluent::LibFluentBit->new;
}

sub new {
   my $class= shift;
   my $self= Fluent::LibFluentBit::flb_create();
   %$self= (@_ == 1 && ref $_[0] eq 'HASH')? %{$_[0]} : @_;
   $self->{started}= !1;
   return $self;
}

sub started { $_[0]{started} }

sub start {
   my $self= shift;
   unless ($self->{started}) {
      $self->flb_start;
      $self->{started}= 1;
   }
}

sub stop {
   my $self= shift;
   if ($self->{started}) {
      $self->flb_stop;
      $self->{started}= 0;
   }
}

sub DESTROY {
   my $self= shift;
   $self->stop;
   $self->flb_destroy;
}

sub new_logger {
   my $self= shift;
   require Fluent::LibFluentBit::Logger;
   $self->start unless $self->{started};
   Fluent::LibFluentBit::Logger->new(context => $self, @_);
}

END {
   undef $default_instance;
}

1;
