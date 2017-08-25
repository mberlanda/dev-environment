package DevEnv::Postgresql {
  use 5.006;
  use strict;
  use warnings;

  use File::Spec;
  use File::Copy qw(copy);

  use Exporter qw(import);
  our @EXPORT = qw(create_pg_user edit_hba_config list_pg_users);
  our %EXPORT_TAGS = (
    all => \@EXPORT
  );

  our $VERSION = '0.01';

  sub psql_version {
    chomp(my $psql_full_version = `psql --version`);
    $psql_full_version =~ /(\d+\.\d+)/;
  }

  sub create_user_cmd {
    my ($either, $db_user) = @_;
    "createuser -s -w $db_user";
  }

  sub create_pg_user_cmd {
    my ($either, $db_user) = @_;
    my $user_psql_cmd = $either->create_user_cmd($db_user);
    "sudo su postgres -c \"$user_psql_cmd\"" ;
  }

  sub create_pg_user {
    my ($either, $db_user) = @_;
    system $either->create_pg_user_cmd($db_user);
  }

  sub list_pg_users {
    system 'psql -U postgres -c "select usename from pg_user;"';
  }

  sub edit_hba_config {
    my $hba_config = hba_config_path();
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
      die "$bkp exists already. Please remove it if you want to change the configuration automatically\n" .
          '$ sudo ' . "rm $hba_config" . "\n" . '$ sudo ' . "mv $bkp $hba_config" ."\n";
    }
  }

  sub hba_config_path {
    File::Spec->catfile(
      File::Spec->rootdir, 'etc', 'postgresql', psql_version(), 'main', 'pg_hba.conf'
    );
  }

}

=head1 NAME

DevEnv::Postgresql

=head1 VERSION

Version 0.01

=head1 SYNOPSYS

The purpose of DevEnv::Postgresql is to provide some utility function for Postgresql configuration after installation

=head1 SUBROUTINES/METHODS

=head2 psql_version

=head2 create_user_cmd

=head2 create_pg_user_cmd

=head2 create_pg_user

=head2 list_pg_users

=head2 find_hba_config_path
This method returns the path of the postgresql config file

=head2 edit_hba_config
This method makes the local connections to the db trusted

=cut

1;
