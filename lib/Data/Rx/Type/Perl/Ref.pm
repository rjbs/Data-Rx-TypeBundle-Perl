use strict;
use warnings;
package Data::Rx::Type::Perl::Ref;
# ABSTRACT: experimental / perl reference type
use parent 'Data::Rx::CommonType::EasyNew';

=head1 SYNOPSIS

  use Data::Rx;
  use Data::Rx::Type::Perl::Ref;
  use Test::More tests => 2;

  my $rx = Data::Rx->new({
    prefix  => {
      perl => 'tag:codesimply.com,2008:rx/perl/',
    },
    type_plugins => [ 'Data::Rx::Type::Perl::Ref' ]
  });

  my $int_ref_rx = $rx->make_schema({
    type       => '/perl/ref',
    referent   => '//int',
  });

  ok(  $int_ref_rx->check(  1 ), "1 is not a ref to an integer");
  ok(! $int_ref_rx->check( \1 ), "\1 is a ref to an integer");

=head1 ARGUMENTS

"referent" indicates another type to which the reference must refer.

=cut

use Carp ();
use Scalar::Util ();

sub type_uri { 'tag:codesimply.com,2008:rx/perl/ref' }

sub guts_from_arg {
  my ($class, $arg, $rx) = @_;
  $arg ||= {};

  for my $key (keys %$arg) {
    next if $key eq 'referent';
    Carp::croak(
      "unknown argument $key in constructing " . $class->type_uri .  " type",
    );
  }

  my $guts = { };

  if ($arg->{referent}) {
    my $ref_checker = $rx->make_schema($arg->{referent});

    $guts->{referent} = $ref_checker;
  }

  return $guts;
}

sub assert_valid {
  my ($self, $value) = @_;

  unless (ref $value and (ref $value eq 'REF' or ref $value eq 'SCALAR')) {
    $self->fail({
      error   => [ qw(type) ],
      message => "found value is not a scalar reference",
      value   => $value,
    });
  }

  if ($self->{referent}) {
    $self->perform_subchecks([
      [
        $$value,
        $self->{referent},
        {
          data_path  => [ [ 'scalar_deref', 'deref', sub { "\${$_[0]}" } ] ],
          check_path => [ [ 'referent', 'key' ] ],
        },
      ],
    ]);
  }

  return 1;
}

1;
