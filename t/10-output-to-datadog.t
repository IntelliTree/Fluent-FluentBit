use strict;
use warnings;
use Test::More;
use Fluent::LibFluentBit;

plan skip_all => 'Require DATADOG_API_KEY for this test'
   unless defined $ENV{DATADOG_API_KEY};

ok( my $flb= Fluent::LibFluentBit->default_instance, 'default_instance' );

$flb->flb_service_set('log_level', 'trace');

my $out= $flb->flb_output("datadog");
$flb->flb_output_set($out,
   Match => '*',
   Host => "http-intake.logs.datadoghq.com",
   TLS => 'on',
   compress => 'gzip',
   apikey => $ENV{DATADOG_API_KEY},
   dd_service => 'unit-test',
   dd_source => 'perl-Fluent-LibFluentBit',
);

my $in= $flb->flb_input("lib");
$flb->start;
for my $i (0..100) {
   $flb->flb_lib_push($in, sprintf("[%d,{\"key1\":\"%ld\"}]", time, $i));
   sleep 1;
}

#ok( my $logger= $flb->new_logger, 'new_logger' );
#ok( $logger->error('test'), "error('test')" );
#for (1..100) { sleep 1; $logger->error('test') }
ok( $flb->stop >= 0, 'flb_stop' );
undef $flb;

done_testing;
