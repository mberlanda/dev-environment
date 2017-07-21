#!/usr/bin/perl
use strict;
use warnings;

use 5.014;
use File::Copy qw(copy);
use File::Spec;
use Try::Tiny;

sub install_packages {
  my @packages = @_;
  say "Installing: " . join(', ', @packages);
  `sudo apt update && sudo apt upgrade -y`;
  my $install_cmd = "sudo apt install " . join(' ', @packages) . " -y";
  `$install_cmd`;
}
sub find_hba_config_path {
  chomp(my $psql_full_version = `psql --version`);
  (my $psql_version) = $psql_full_version =~ /(\d+\.\d+)/;
  return File::Spec->catfile(File::Spec->rootdir, 'etc', 'postgresql', $psql_version, 'main', 'pg_hba.conf');
}
sub edit_hba_config {
  my ($hba_config) = @_;
  my $bkp = $hba_config . ".bak";
  unless (-e $bkp) {
    copy $hba_config,$bkp;
    (open IN, "<$bkp") or die "Cannot open '$bkp': $!";
    (open OUT, ">$hba_config") or die "Cannot open '$hba_config': $!";
    while(<IN>){
      unless (/^#/) {
        s/peer/trust/gi;
      }
      print OUT $_;
    }
    `sudo service postgresql restart`;
  } else {
    say "$bkp exists already. Please remove it if you want to change the configuration automatically";
    say '$ sudo ' . "rm $hba_config";
    say '$ sudo ' . "mv $bkp $hba_config";
  }
}

BEGIN {
  if ($< != 0){
    say "This script must be run as sudo";
    exit(0);
  }
  my $db_user = $ARGV[0];
  unless ($db_user) {
    say "Please provide a username to be generated as argv";
    exit(0);
  }

  my @packages = (
    'postgresql',
    'postgresql-contrib',
    'libpq-dev'
  );
  install_packages(@packages);
  my $hba_config = find_hba_config_path();
  edit_hba_config($hba_config);
  my $user_psql_cmd = "createuser -s -w $db_user";
  my $psql_cmd = "sudo su postgres -c \"$user_psql_cmd\"" ;
  system $psql_cmd;
  system 'psql -U postgres -c "select usename from pg_user;"';
}
