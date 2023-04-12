package Fluent::LibFluentBit::Logger;
use strict;
use warnings;
use Carp;
use JSON::MaybeXS;

sub new {
   my $class= shift;
   my %attrs= @_;
   defined $attrs{context} or croak "Missing required attribute 'context'";
   $attrs{ffd} //= $attrs{context}->flb_input("lib");
   $attrs{ffd} >= 0 or croak "Can't create 'lib' input to libfluent-bit";
   bless \%attrs, $class;
}

sub _log_data {
   my ($self, $data, $level)= @_;
   $data= { message => $data } unless ref $data eq 'HASH';
   my $code= $self->{context}->flb_lib_push($self->{ffd}, encode_json([ time, $data ]));
   $code >= 0 or croak "flb_lib_push failed: $code";
   return $self;
}

sub info {
   $_[0]->_log_data( $_[1], 'info' );
}

sub warn {
   $_[0]->_log_data( $_[1], 'warn' );
}

sub error {
   $_[0]->_log_data( $_[1], 'error' );
}

1;

