#!/usr/bin/perl
use strict;
use warnings;

use DevEnv::Util qw(install_packages);
use DevEnv::Postgresql qw(create_pg_user edit_hba_config list_pg_users);

# I create a db user with the same name of the current user in order
# to grant peer connectivity in local

# my $db_user = $ARGV[0];
# die "Please provide a username to be generated as argument" unless ($db_user);

my @packages = (
  'postgresql',
  'postgresql-contrib',
  'libpq-dev'
);

{
  my ($user) = split / /, `who`;
  die "This script must be run as sudo" unless ($< == 0);
  install_packages(@packages);
  edit_hba_config();
  create_pg_user($user);
  list_pg_users();
}
