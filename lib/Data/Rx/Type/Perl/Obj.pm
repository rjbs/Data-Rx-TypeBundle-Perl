use strict;
use warnings;
package Data::Rx::Type::Perl::Obj;
# ABSTRACT: experimental / perl object type
use parent 'Data::Rx::CommonType::EasyNew';

=head1 SYNOPSIS

  use Data::Rx;
  use Data::Rx::Type::Perl::Obj;
  use Test::More tests => 2;

  my $rx = Data::Rx->new({
    prefix  => {
      perl => 'tag:codesimply.com,2008:rx/perl/',
    },
    type_plugins => [ 'Data::Rx::Type::Perl::Obj' ]
  });

  my $isa_rx = $rx->make_schema({
    type       => '/perl/obj',
    isa        => 'Data::Rx',
  });

  ok($isa_rx->check($rx),   "a Data::Rx object isa Data::Rx /perl/obj");
  ok(! $isa_rx->check( 1 ), "1 is not a Data::Rx /perl/obj");

=head1 ARGUMENTS

"isa" and "does" ensure that the object passes the relevant test for the
identifier given.

=cut

use Carp ();
use Scalar::Util ();

sub type_uri { 'tag:codesimply.com,2008:rx/perl/obj' }

sub guts_from_arg {
  my ($class, $arg, $rx, $type) = @_;
  $arg ||= {};

  for my $key (keys %$arg) {
    next if $key eq 'isa' or $key eq 'does';
    Carp::croak(
      "unknown argument $key in constructing " . $class->tag_uri .  "type",
    );
  }

  return {
    isa  => $arg->{isa},
    does => $arg->{does},
  };
}

sub assert_valid {
  my ($self, $value) = @_;

  local $@;

  unless (Scalar::Util::blessed($value)) {
    $self->fail({
      error   => [ qw(type) ],
      message => "found value is not blessed",
      value   => $value,
    });
  }

  if (defined $self->{isa} and not eval { $value->isa($self->{isa}) }) {
    $self->fail({
      error   => [ qw(isa) ],
      message => "found value is not isa $self->{isa}",
      value   => $value,
    });
  }

  if (defined $self->{does} and not eval { $value->DOES($self->{does}) }) {
    $self->fail({
      error   => [ qw(does) ],
      message => "found value does not do role $self->{does}",
      value   => $value,
    });
  }

  return 1;
}

1;
