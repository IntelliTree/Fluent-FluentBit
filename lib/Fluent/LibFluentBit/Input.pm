package Fluent::LibFluentBit::Input;
# VERSION
use parent 'Fluent::LibFluentBit::Component';

# ABSTRACT: Fluent-Bit input

=head1 SYNOPSIS

 my $input= $libfluentbit->add_input($plugin_name);
 $input->configure( %config );

=head1 DESCRIPTION

See L<Fluent::LibFluentBit::Component> for API.

See L<https://docs.fluentbit.io/manual/pipeline/inputs|fluent-bit documentation>
for the different types and attributes for inputs.

=cut

sub _build_id {
   my ($self, $name)= @_;
   $self->context->flb_input($name)
}

sub _set_attr {
   my ($self, $key, $val)= @_;
   $self->context->flb_input_set($self->id, $key, $val);
}

1;
