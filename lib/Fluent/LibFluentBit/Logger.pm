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

sub include_caller {
   $_[0]{include_caller}= $_[1] if @_ > 1;
   $_[0]{include_caller}
}

sub _log_data {
   my ($self, $data, $level)= @_;
   $data= ref $data eq 'HASH'? { %$data } : { message => $data };
   $data->{status}= $level;
   if ($self->{include_caller}) {
      my ($i, $pkgname, $file, $line, $callname)= (1);
      while (($pkgname, $file, $line)= caller($i++) and substr($pkgname,0,5) eq 'Log::') {}
      # up one more level tells us the name of the function it happened in.
      # ...but skip functions named '(eval)'
      while (($callname)= (caller($i++))[3] and $callname eq '(eval)') {}
      $data->{caller}= $callname // $pkgname;
      $data->{file}= $file;
      $data->{line}= $line;
   }
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

