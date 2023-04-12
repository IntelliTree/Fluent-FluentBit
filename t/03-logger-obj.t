use strict;
use warnings;
use Test::More;
use Fluent::LibFluentBit;

ok( my $flb= Fluent::LibFluentBit->default_instance, 'default_instance' );
ok( my $logger= $flb->new_logger, 'new_logger' );
ok( $logger->error('test'), "error('test')" );
undef $flb;

done_testing;
