#!/usr/bin/perl
use strict;
use warnings;

use 5.014;
use File::Copy qw(copy);
use File::Spec::Functions;
use Try::Tiny;
use Cwd;

my %GITAWAREPROMPT = (
  url => 'git@github.com:jimeh/git-aware-prompt.git',
  folder => catdir($ENV{HOME}, ".bash"),
  destination => catdir($ENV{HOME}, ".bash", "git-aware-prompt"),
  config => [(
    'export GITAWAREPROMPT=~/.bash/git-aware-prompt',
    'source "${GITAWAREPROMPT}/main.sh"',
    'export PS1="\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "'
  )]
);

unless (-d $GITAWAREPROMPT{destination}) {
  my $folder = $GITAWAREPROMPT{folder};
  mkdir($folder) unless(-d $folder);
  chdir($folder) or die "Cannot check to '$folder': $!";
  my $clone_cmd = "git clone $GITAWAREPROMPT{url}";
  `$clone_cmd`;
}

my $bashrc = catfile($ENV{HOME}, '.bashrc');
my $to_config = 1;

open(BASHRC,  "<",  $bashrc)  or die "Can't open '$bashrc': $!";
while(<BASHRC>) {
  if (/# Gitaware prompt settings/){
    $to_config = 0;
  }
}
if ($to_config) {
  my $bkp = $bashrc . ".bak";
  copy $bashrc, $bkp;
  open(BASHRC, ">>", $bashrc) or die "Could not open '$bashrc': $!";
  say BASHRC "# Gitaware prompt settings";
  foreach(@{$GITAWAREPROMPT{config}}){ say BASHRC; }
  say BASHRC '';
  close BASHRC;
  say "$bashrc updated."
} else {
  say "$bashrc already up to date."
}
