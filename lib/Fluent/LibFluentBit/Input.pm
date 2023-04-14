package Fluent::LibFluentBit::Input;
use parent 'Fluent::LibFluentBit::Component';

sub _build_id {
   my ($self, $name)= @_;
   $self->context->flb_input($name)
}

sub _set_attr {
   my ($self, $key, $val)= @_;
   $self->context->flb_input_set($self->id, $key, $val);
}

1;
