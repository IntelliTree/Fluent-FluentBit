package Fluent::LibFluentBit::Filter;
use parent 'Fluent::LibFluentBit::Component';

sub _build_id {
   my ($self, $name)= @_;
   $self->context->flb_filter($name)
}

sub _set_attr {
   my ($self, $key, $val)= @_;
   $self->context->flb_filter_set($self->id, $key, $val);
}

1;
