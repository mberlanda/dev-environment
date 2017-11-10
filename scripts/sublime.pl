#!/usr/bin/perl
use strict;
use warnings;
use DevEnv::Util qw(install_packages install_yum_packages);

use File::Basename qw(dirname);
use File::Spec::Functions qw(splitdir catfile);
use File::Copy;

# https://www.sublimetext.com/docs/3/linux_repositories.html
sub bkp_sublime_config {
  my $cfg = shift;
  move($cfg, "$cfg.bak") or die "Backup failed ($cfg): $!";
}

sub sublime_config {
  my $script_dir = dirname(__FILE__) or die "Cannot get __FILE__ path: $!";
  return catfile($script_dir, '../config/Preferences.sublime-settings');
}

sub replace_sublime_config {
  my ($user) = split / /, `who`;
  my $user_cfg = "$ENV{'HOME'}/.config/sublime-text-3/Packages/User/Preferences.sublime-settings";
  bkp_sublime_config($user_cfg);
  my $custom_cfg = &sublime_config;
  copy($custom_cfg, $user_cfg) or die "The move operation failed: $!";
  print "Successfully Replaced $custom_cfg to $user_cfg\n";
}

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
  # die "This script must be run as sudo" unless ($< == 0);
  print "Enter your ecosystem (apt or yum): " . "\n";
  chomp (my $ecosystem = <STDIN>);
  unless (grep $_ eq $ecosystem, @allowed_ecosystems) {
    die "Invalid option provided: $ecosystem\nIt should be included in: " .
        join(', ', @allowed_ecosystems) . "\n";
  } else {
    system $_ foreach @{$sublime_commands->{$ecosystem}->{prepare}};
    $sublime_commands->{$ecosystem}->{install}->('sublime-text');
    replace_sublime_config
  }
}
