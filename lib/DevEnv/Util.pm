package DevEnv::Util {
  use 5.006;
  use strict;
  use warnings;

  use Exporter qw(import);
  our @EXPORT = qw(install_packages install_modules);
  our %EXPORT_TAGS = (
    all => \@EXPORT
  );

  our $VERSION = '0.01';

  sub install_packages {
    my ($self, @packages) = @_;
    print "Installing: " . join(', ', @packages) . "\n";
    system apt_refresh_cmd();
    system apt_install_cmd(@packages);
  }

  sub install_modules {
    my ($self, @modules) = @_;
    system cpanm_install_cmd(@modules);
  }

  sub apt_refresh_cmd {
    "sudo apt update && sudo apt upgrade -y";
  }

  sub apt_install_cmd {
    my ($self, @packages) = @_;
    unless (@packages){
      die "apt_install_cmd() takes at leat one argument";
    }
    "sudo apt install " . join(' ', @packages) . " -y";
  }

  sub cpanm_install_cmd {
    my ($self, @modules) = @_;
    unless (@modules){
      die "cpanm_install_cmd() takes at leat one argument";
    }
    "sudo cpanm -i " . join(' ', @modules);
  }
}

=head1 NAME

DevEnv::Util

=head1 VERSION

Version 0.01

=head1 SYNOPSYS

The purpose of DevEnv::Util is to provide a simple interface for installing packages and perl modules.
The current implementation works only on Debian, but it should be pretty easy to adapt this API to work
with other UNIX distro as well.

=head1 SUBROUTINES/METHODS

=head2 install_packages
This method installs apt packages passed as arguments

  use DevEnv::Util qw(:all);
  my @packages = qw(curl git);
  install_packages(@packages);

=head2 install_modules
This method installs perl modules passed as arguments

  use DevEnv::Util qw(:all);
  my @modules = ('File::Copy', 'File::Spec::Functions' );
  install_modules(@modules);

=head2 apt_refresh_cmd
This private method returns the command to update and upgrade the apt repository

=head2 apt_install_cmd
This private method build the apt install command from an array of packages

=head2 cpanm_install_cmd
This private method build the cpanm install command from an array of modules

=cut

1;
