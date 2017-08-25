#!/usr/bin/perl
use strict;
use warnings;
use DevEnv::Util qw(install_packages);

my @packages =  qw(clipit curl git htop vim);
map { push @packages, $_ } @ARGV;

install_packages(@packages);
