#!/usr/bin/perl
use strict;
use warnings;
use DevEnv::Util qw(install_packages install_yum_packages);

my $sublime_commands = {
  apt => {
    prepare => [
      'wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -',
      'sudo apt-get install apt-transport-https',
      'echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list'
    ],
    install => \&install_packages
  },
  yum => {
    prepare => [
      'sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg'.
      'sudo yum-config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo'
    ],
    install => \&install_yum_packages
  }
};

my @allowed_ecosystems = keys(%$sublime_commands);

{
  die "This script must be run as sudo" unless ($< == 0);
  print "Enter your ecosystem (apt or yum): " . "\n";
  chomp (my $ecosystem = <STDIN>);
  unless (grep $_ eq $ecosystem, @allowed_ecosystems) {
    die "Invalid option provided: $ecosystem\nIt should be included in: " .
        join(', ', @allowed_ecosystems) . "\n";
  } else {
    system $_ foreach @{$sublime_commands->{$ecosystem}->{prepare}};
    $sublime_commands->{$ecosystem}->{install}->('sublime-text');
  }
}
