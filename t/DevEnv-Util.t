#!perl -T

use strict;
use warnings;
use Test::More tests => 11;
use Test::Output;

BEGIN {
  use_ok( 'DevEnv::Util' ) || BAIL_OUT();
}

# Methods definition
ok(defined &DevEnv::Util::install_packages, 'DevEnv::Util::install_packages is defined');
ok(defined &DevEnv::Util::install_modules, 'DevEnv::Util::install_modules is defined');
ok(defined &DevEnv::Util::apt_refresh_cmd, 'DevEnv::Util::apt_refresh_cmd is defined');
ok(defined &DevEnv::Util::apt_install_cmd, 'DevEnv::Util::apt_install_cmd is defined');
ok(defined &DevEnv::Util::cpanm_install_cmd, 'DevEnv::Util::cpanm_install_cmd is defined');

is(
  DevEnv::Util->apt_refresh_cmd(),
  'sudo apt update && sudo apt upgrade -y',
  'apt_refresh_cmd() works as expected'
);

my @packages = qw(git curl);
is(
  DevEnv::Util->apt_install_cmd(@packages),
  'sudo apt install git curl -y',
  'apt_install_cmd() works with valid arguments'
);
{
  eval { DevEnv::Util->apt_install_cmd() } or my $at = $@;
  like( $at, qr/takes at leat one argument/, 'apt_install_cmd() dies with no argument' );
}

my @modules = qw(Test::More Test::Output);
is(
  DevEnv::Util->cpanm_install_cmd(@modules),
  'sudo cpanm -i Test::More Test::Output',
  'cpanm_install_cmd() works with valid arguments'
);
{
  eval { DevEnv::Util->cpanm_install_cmd() } or my $at = $@;
  like( $at, qr/takes at leat one argument/, 'cpanm_install_cmd() dies with no argument' );
}
