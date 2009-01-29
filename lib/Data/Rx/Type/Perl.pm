use strict;
use warnings;
package Data::Rx::Type::Perl;
our $VERSION = '0.001';
# ABSTRACT: experimental / perl types

use Data::Rx::Type::Perl::Obj;

=head1 SYNOPSIS

  use Data::Rx;
  use Data::Rx::Type::Perl;
  use Test::More tests => 2;

  my $rx = Data::Rx->new({
    prefix  => {
      perl => 'tag:codesimply.com,2008:rx/perl/',
    },
    type_plugins => [ Data::Rx::Type::Perl->type_plugins ],
  });

  my $isa_rx = $rx->make_schema({
    type       => '/perl/obj',
    isa        => 'Data::Rx',
  });

  ok($isa_rx->check($rx),   "a Data::Rx object isa Data::Rx /perl/obj");
  ok(! $isa_rx->check( 1 ), "1 is not a Data::Rx /perl/obj");

=cut

sub type_plugins {
  return qw(Data::Rx::Type::Perl::Obj);
}

1;
