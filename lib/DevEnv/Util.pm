package DevEnv::Util {
  use 5.006;
  use strict;
  use warnings;
  use Exporter qw(import);
  our @EXPORT = qw(install_packages install_modules);

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
