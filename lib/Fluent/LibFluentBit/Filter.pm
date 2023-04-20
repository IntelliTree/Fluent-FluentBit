package Fluent::LibFluentBit::Filter;
# VERSION
use parent 'Fluent::LibFluentBit::Component';

# ABSTRACT: Fluent-Bit filter

=head1 SYNOPSIS

 my $filter= $libfluentbit->add_filter($plugin_name);
 $filter->configure( %config );

=head1 DESCRIPTION

See L<Fluent::LibFluentBit::Component> for API.

See L<fluent-bit documentation|https://docs.fluentbit.io/manual/pipeline/filters>
for the different types and attributes for filters.

=cut

sub _build_id {
   my ($self, $name)= @_;
   $self->context->flb_filter($name)
}

sub _set_attr {
   my ($self, $key, $val)= @_;
   $self->context->flb_filter_set($self->id, $key, $val);
}

1;
