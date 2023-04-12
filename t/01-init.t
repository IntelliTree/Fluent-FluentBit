use strict;
use warnings;
use Test::More;

use_ok( 'Fluent::LibFluentBit' ) or BAIL_OUT;

ok( my $flb= Fluent::LibFluentBit::flb_create(), 'flb_create' );
local $@;
is( eval { $flb->flb_destroy; 1; }, 1, 'flb_destroy' )
   or diag $@;

done_testing;
