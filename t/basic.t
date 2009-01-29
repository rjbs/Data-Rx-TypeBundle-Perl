use strict;
use warnings;

use Data::Rx;
use Data::Rx::Type::Perl;
use Test::More tests => 2;

my $rx = Data::Rx->new({
  prefix  => {
    perl => 'tag:codesimply.com,2008:rx/perl/',
  },
  type_plugins => [ Data::Rx::Type::Perl->type_plugins ]
});

my $isa_rx = $rx->make_schema({
  type       => '/perl/obj',
  isa        => 'Data::Rx',
});

ok($isa_rx->check($rx),   "a Data::Rx object isa Data::Rx /perl/obj");
ok(! $isa_rx->check( 1 ), "1 is not a Data::Rx /perl/obj");
