package Fluent::LibFluentBit::Logger;
use strict;
use warnings;
use Carp;
use Time::HiRes 'time';
use JSON::MaybeXS;

sub new {
   my $class= shift;
   my %attrs= @_;
   defined $attrs{context} or croak "Missing required attribute 'context'";
   defined $attrs{input_id} or croak "Missing required attribute 'input_id'";
   $attrs{context}->start unless $attrs{context}->started;
   bless \%attrs, $class;
}

sub _log_data {
   my ($self, $data, $level)= @_;
   $data= { message => $data } unless ref $data eq 'HASH';
   $data->{status}= $level;
   my $code= $self->{context}->flb_lib_push($self->{input_id}, encode_json([ time, $data ]));
   $code >= 0 or croak "flb_lib_push failed: $code";
   return $self;
}

sub trace { $_[0]->_log_data( $_[1], 'trace') }
sub debug { $_[0]->_log_data( $_[1], 'debug') }
sub info  { $_[0]->_log_data( $_[1], 'info' ) }
sub warn  { $_[0]->_log_data( $_[1], 'warn' ) }
sub notice{ $_[0]->_log_data( $_[1], 'notice') }
sub error { $_[0]->_log_data( $_[1], 'error') }

1;

