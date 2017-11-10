#!/usr/bin/perl
use strict;
use warnings;
use DevEnv::Util qw(install_packages);

my $apt_dependencies = [qw(
  software-properties-common
  )];


my $rvm_global_cmd = [
  'sudo apt-add-repository -y ppa:rael-gc/rvm',
  'sudo apt update',
  'sudo apt install rvm',
];

{
  die "This script must be run as sudo" unless ($< == 0);
  install_packages(@{$apt_dependencies});
  system $_ foreach @{$rvm_global_cmd};
}
