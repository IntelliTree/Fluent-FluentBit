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
   my $inputs= delete $self->{inputs};
   my $filters= delete $self->{filters};
   my $outputs= delete $self->{outputs};
   for (keys %$self) {
      $self->flb_service_set($_, $self->{$_}) >= 0
         or carp "Invalid fluent-bit service attribute '$_'";
   }
   $self->{started}= !1;
   if ($inputs) {
      $self->add_input($_) for @$inputs;
   }
   if ($outputs) {
      $self->add_output($_) for @$outputs;
   }
   if ($filters) {
      $self->add_filter($_) for @$filters;
   }
   return $self;
}

sub _collect_subobject_config {
   my %cfg;
   $cfg{name}= shift if @_ && !ref $_[0];
   my @attrs= (ref $_[0] eq 'HASH')? %{$_[0]} : @_;
   for (my $i= 0; $i < @attrs; $i+= 2) {
      # Make all keys lowercase
      $cfg{lc $attrs[$i]}= $attrs[$i+1];
   }
   # name must be defined
   defined $cfg{name} or croak "Missing ->{name} in object config";
   \%cfg;
}

sub inputs { $_[0]{inputs} }
sub add_input {
   my $self= shift;
   my $config= &_collect_subobject_config;
   $config->{context}= $self;
   my $obj= Fluent::LibFluentBit::Input->new($config);
   push @{ $self->{inputs} }, $obj;
   $obj;
}

sub filters { $_[0]{filters} }
sub add_filter {
   my $self= shift;
   my $config= &_collect_subobject_config;
   $config->{context}= $self;
   my $obj= Fluent::LibFluentBit::Filter->new($config);
   push @{ $self->{filters} }, $obj;
   $obj;
}

sub outputs { $_[0]{outputs} }
sub add_output {
   my $self= shift;
   my $config= &_collect_subobject_config;
   $config->{context}= $self;
   my $obj= Fluent::LibFluentBit::Output->new($config);
   push @{ $self->{outputs} }, $obj;
   $obj;
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
