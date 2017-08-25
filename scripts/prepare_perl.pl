#!/usr/bin/perl
use strict;
use warnings;

use DevEnv::Util qw(:all);

my @packages = qw(cpanminus git curl );
my @modules = (
  'File::Copy',
  'File::Spec::Functions',
  'Try::Tiny',
  'Test::More',
  'Test::Output'
);

install_packages(@packages);
install_modules(@modules);
