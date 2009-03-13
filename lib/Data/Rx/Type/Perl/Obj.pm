use strict;
use warnings;
package Data::Rx::Type::Perl::Obj;
# ABSTRACT: experimental / perl object type

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

sub new_checker {
  my ($class, $arg, $rx) = @_;
  $arg ||= {};

  for my $key (keys %$arg) {
    next if $key eq 'isa' or $key eq 'does';
    Carp::croak(
      "unknown argument $key in constructing " . $class->tag_uri .  "type",
    );
  }

  my $self = {
    isa  => $arg->{isa},
    does => $arg->{does},
  };

  return bless $self => $class;
}

sub check {
  my ($self, $value) = @_;

  local $@;
  return unless Scalar::Util::blessed($value);
  return if defined $self->{isa}  and not eval { $value->isa($self->{isa}) };
  return if defined $self->{does} and not eval { $value->DOES($self->{does}) };
  return 1;
}

1;
