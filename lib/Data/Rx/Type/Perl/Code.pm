use strict;
use warnings;
package Data::Rx::Type::Perl::Code;
# ABSTRACT: experimental / perl coderef type
use parent 'Data::Rx::CommonType::EasyNew';

=head1 SYNOPSIS

  use Data::Rx;
  use Data::Rx::Type::Perl::Code;
  use Test::More tests => 2;

  my $rx = Data::Rx->new({
    prefix  => {
      perl => 'tag:codesimply.com,2008:rx/perl/',
    },
    type_plugins => [ 'Data::Rx::Type::Perl::Code' ]
  });

  my $is_code = $rx->make_schema({
    type       => '/perl/code',
  });

  ok($is_code->check( sub {} ), "a coderef is code");
  ok(! $is_code->check( 1 ),    "1 is not code");

=head1 ARGUMENTS

If given, the C<prototype> argument will require that the code has the given
prototype.

=cut

use Carp ();
use Scalar::Util ();

sub type_uri { 'tag:codesimply.com,2008:rx/perl/code' }

sub guts_from_arg {
  my ($class, $arg, $rx) = @_;
  $arg ||= {};

  for my $key (keys %$arg) {
    next if $key eq 'prototype';
    Carp::croak(
      "unknown argument $key in constructing " . $class->tag_uri .  "type",
    );
  }

  my $prototype_schema
    = (! exists $arg->{prototype})
    ? $rx->make_schema('tag:codesimply.com,2008:rx/core/any')

    : (! defined $arg->{prototype})
    ? $rx->make_schema('tag:codesimply.com,2008:rx/core/nil')

    : $rx->make_schema({
        type  => 'tag:codesimply.com,2008:rx/core/str',
        value => $arg->{prototype}
      });

  return { prototype_schema => $prototype_schema };
}

sub check {
  my ($self, $value) = @_;

  return unless ref $value;

  # Should probably be checking _CALLABLE. -- rjbs, 2009-03-12
  return unless Scalar::Util::reftype($value) eq 'CODE';

  return unless $self->{prototype_schema}->check(prototype $value);

  return 1;
}

1;
