package Fluent::LibFluentBit::Output;
use parent 'Fluent::LibFluentBit::Component';

sub _build_id {
   my ($self, $name)= @_;
   $self->context->flb_output($name)
}

sub _set_attr {
   my ($self, $key, $val)= @_;
   $self->context->flb_output_set($self->id, $key, $val);
}

1;
