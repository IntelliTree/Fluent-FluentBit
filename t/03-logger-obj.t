use strict;
use warnings;
use Test::More;
use Fluent::LibFluentBit -config => { log_level => $ENV{DEBUG}? 'debug' : 'info' };

ok( my $logger= Fluent::LibFluentBit->new_logger, 'new_logger' );
for my $level (qw( trace debug info notice warn error )) {
   ok( $logger->$level($level), $level );
}

done_testing;
