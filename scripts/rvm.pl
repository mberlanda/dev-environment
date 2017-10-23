#!/usr/bin/perl
use strict;
use warnings;

my $rvm_commands = [
  'gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB',
  '\curl -sSL https://get.rvm.io | bash -s stable --ruby --rails'
];

{
  die "This script must be run as sudo" unless ($< == 0);
  system $_ foreach @{$rvm_commands};
}
