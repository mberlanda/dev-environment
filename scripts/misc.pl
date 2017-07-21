#!/usr/bin/perl
use strict;
use warnings;

use 5.014;

my @packages = qw(clipit htop vim curl git);
install_packages(@packages);

sub install_packages {
  my @packages = @_;
  say "Installing: " . join(', ', @packages);
  `sudo apt update && sudo apt upgrade -y`;
  my $install_cmd = "sudo apt install " . join(' ', @packages) . " -y";
  system $install_cmd;
}
