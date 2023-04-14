package Fluent::LibFluentBit::Component;
use strict;
use warnings;
use Carp;
use Scalar::Util;

=head1 DESCRIPTION

This is a base class for the sub-objects of the FluentBit library, such as input, output,
and filters.

=cut

sub context { $_[0]{context} }
sub id      { $_[0]{id} }
sub name    { $_[0]{name} }

sub new {
   my $class= shift;
   my %attrs= @_ == 1 && ref $_[0] eq 'HASH'? %{$_[0]} : @_;
   my $context= delete $attrs{context};
   ref $context or croak "Attribute 'context' is required and must be a LibFluentBit instance";
   my $name= delete $attrs{name};
   defined $name && length $name or croak "Attribute 'name' is required";
   my $self= bless { context => $context, name => $name }, $class;
   Scalar::Util::weaken($self->{context});
   $self->{id}= defined $attrs{id}? delete $attrs{id} : $self->_build_id($name);
   $self->configure(%attrs);
}

sub configure {
   my $self= shift;
   my %conf= @_ == 1 && ref $_[0] eq 'HASH'? %{$_[0]} : @_;

   for (keys %conf) {
      if ($self->_set_attr($_, $conf{$_}) >= 0) {
         $self->{lc $_}= $conf{$_};
      } else {
         carp "Invalid fluent-bit attribute '$_' = '$conf{$_}'";
      }
   }
   return $self;
}

1;
