#!/usr/bin/perl
use strict;
use warnings;
use DevEnv::Util qw(install_packages);

my @packages = qw(haskell-platform);
install_packages(@packages);
