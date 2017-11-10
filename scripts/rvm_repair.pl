#!/usr/bin/perl
use strict;
use warnings;
use DevEnv::Util qw(install_packages);

my $rvm_repair_cmd = [
  'rvm install ruby',
  'rvmsudo rvm get stable --auto-dotfiles',
  'rvm fix-permissions system',
  'rvm reload'
];

my $gems_to_install = [qw(bundler rails)];

my $gem_cmd = sub {
  return 'gem install ' . $_;
};

{
  system $_ foreach @{$rvm_repair_cmd};
  print "Now reload the shell and install some basic gems such as: \n";
  print $_ ."\n" foreach map {$gem_cmd->($_)} @{$gems_to_install};
}
