#!perl -T

use strict;
use warnings;
use Test::More tests => 10;
use Test::Output;

BEGIN {
  use_ok( 'DevEnv::Postgresql' ) || BAIL_OUT();
}

# Methods definition
ok(defined &DevEnv::Postgresql::edit_hba_config, 'DevEnv::Postgresql::edit_hba_config is defined');
ok(defined &DevEnv::Postgresql::hba_config_path, 'DevEnv::Postgresql::hba_config_path is defined');
ok(defined &DevEnv::Postgresql::psql_version, 'DevEnv::Postgresql::psql_version is defined');
ok(defined &DevEnv::Postgresql::create_user_cmd, 'DevEnv::Postgresql::create_user_cmd is defined');
ok(defined &DevEnv::Postgresql::create_pg_user_cmd, 'DevEnv::Postgresql::create_pg_user_cmd is defined');
ok(defined &DevEnv::Postgresql::create_pg_user, 'DevEnv::Postgresql::create_pg_user is defined');
ok(defined &DevEnv::Postgresql::list_pg_users, 'DevEnv::Postgresql::list_pg_users is defined');

is(
  DevEnv::Postgresql->create_user_cmd("kupta"),
  'createuser -s -w kupta',
  'create_user_cmd() generate the expected psql statement'
);

is(
  DevEnv::Postgresql->create_pg_user_cmd("kupta"),
  'sudo su postgres -c "createuser -s -w kupta"',
  'create_pg_user_cmd() generate the expected psql statement'
);
