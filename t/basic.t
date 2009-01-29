use strict;
use warnings;

use Data::Rx 0.005;
use Data::Rx::TypeBundle::Perl;
use Test::More tests => 2;

my $rx = Data::Rx->new({
  type_plugins => [ qw(Data::Rx::TypeBundle::Perl) ]
});

my $isa_rx = $rx->make_schema({
  type       => '/perl/obj',
  isa        => 'Data::Rx',
});

ok($isa_rx->check($rx),   "a Data::Rx object isa Data::Rx /perl/obj");
ok(! $isa_rx->check( 1 ), "1 is not a Data::Rx /perl/obj");
