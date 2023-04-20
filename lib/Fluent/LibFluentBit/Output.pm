package Fluent::LibFluentBit::Output;
# VERSION
use parent 'Fluent::LibFluentBit::Component';

# ABSTRACT: Fluent-Bit output

=head1 SYNOPSIS

 my $output= $libfluentbit->add_output($plugin_name);
 $output->configure( %config );

=head1 DESCRIPTION

See L<Fluent::LibFluentBit::Component> for API.

See L<fluent-bit documentation|https://docs.fluentbit.io/manual/pipeline/outputs>
for the different types and attributes for outputs.

=cut

sub _build_id {
   my ($self, $name)= @_;
   $self->context->flb_output($name)
}

sub _set_attr {
   my ($self, $key, $val)= @_;
   $self->context->flb_output_set($self->id, $key, $val);
}

1;
