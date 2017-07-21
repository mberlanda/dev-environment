#!/usr/bin/perl
use strict;
use warnings;

use 5.014;

my @packages = qw(cpanminus);
install_packages(@packages);
my @modules = (
  'File::Copy',
  'File::Spec::Functions',
  'Try::Tiny'
);
install_modules(@modules);

sub install_packages {
  my @packages = @_;
  say "Installing: " . join(', ', @packages);
  `sudo apt update && sudo apt upgrade -y`;
  my $install_cmd = "sudo apt install " . join(' ', @packages) . " -y";
  `$install_cmd`;
}

sub install_modules {
  my @modules = @_;
  my $install_cmd = "sudo cpanm " . join(' ', @modules);
  system $install_cmd;
}
