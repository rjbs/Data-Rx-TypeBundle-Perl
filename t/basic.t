use strict;
use warnings;

use Data::Rx 0.005;
use Data::Rx::TypeBundle::Perl;
use Test::More tests => 18;

my $rx = Data::Rx->new({
  type_plugins => [ qw(Data::Rx::TypeBundle::Perl) ]
});

my $isa_rx = $rx->make_schema({
  type       => '/perl/obj',
  isa        => 'Data::Rx',
});

ok($isa_rx->check($rx),   "a Data::Rx object isa Data::Rx /perl/obj");
ok(! $isa_rx->check( 1 ), "1 is not a Data::Rx /perl/obj");

{
  my $is_code = $rx->make_schema({
    type       => '/perl/code',
  });

  ok(  $is_code->check( sub      {} ), 'proto:    // sub      {} == ok');
  ok(  $is_code->check( sub ()   {} ), 'proto:    // sub ()   {} != ok');
  ok(  $is_code->check( sub ($$) {} ), 'proto:    // sub ($$) {} != ok');
  ok(! $is_code->check( 1 ),           '1 is not code');
}

{
  my $is_code = $rx->make_schema({
    type      => '/perl/code',
    prototype => undef,
  });

  ok(  $is_code->check( sub      {} ), 'proto: ~  // sub      {} == ok');
  ok(! $is_code->check( sub ()   {} ), 'proto: ~  // sub ()   {} != ok');
  ok(! $is_code->check( sub ($$) {} ), 'proto: ~  // sub ($$) {} != ok');
  ok(! $is_code->check( 1 ),    "1 is not code");
}

{
  my $is_code = $rx->make_schema({
    type      => '/perl/code',
    prototype => '',
  });

  ok(! $is_code->check( sub      {} ), 'proto: "" // sub      {} != ok');
  ok(  $is_code->check( sub ()   {} ), 'proto: "" // sub ()   {} == ok');
  ok(! $is_code->check( sub ($$) {} ), 'proto: "" // sub ($$) {} != ok');
  ok(! $is_code->check( 1 ),    "1 is not code");
}

{
  my $is_code = $rx->make_schema({
    type      => '/perl/code',
    prototype => '$$',
  });

  ok(! $is_code->check( sub      {} ), 'proto: $$ // sub      {} != ok');
  ok(! $is_code->check( sub ()   {} ), 'proto: $$ // sub ()   {} != ok');
  ok(  $is_code->check( sub ($$) {} ), 'proto: $$ // sub ($$) {} == ok');
  ok(! $is_code->check( 1 ),    "1 is not code");
}
