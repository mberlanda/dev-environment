#!/usr/bin/perl
use strict;
use warnings;

use DevEnv::Util qw(install_packages);
use DevEnv::Postgresql qw(create_pg_user edit_hba_config list_pg_users);

die "This script must be run as sudo" unless ($< == 0);
my $db_user = $ARGV[0];
die "Please provide a username to be generated as argument" unless ($db_user);

my @packages = (
  'postgresql',
  'postgresql-contrib',
  'libpq-dev'
);

install_packages(@packages);
edit_hba_config();
create_pg_user($db_user);
list_pg_users();
