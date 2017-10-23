# Dev Environment

I have created a few scripts to setup a development environment.


## Instructions

### Run tests

```
$ perl -t -Ilib t/DevEnv-Util.t
```

### Configuration

- add [.gitconfig](config/.gitconfig) to the home directory
- Terminal > Preferences logged bash

### Scripts

```
$ perl -Ilib scripts/<script-name>
```

- [prepare_perl.pl](scripts/prepare_perl.pl): `cpanminus` and basic Perl modules
- [misc.pl](scripts/misc.pl): `clipit`, `htop`, `vim`, `curl`, `git` by default, just add additional packages as arguments
- [gitawareprompt.pl](scripts/gitawareprompt.pl): install `git-aware-prompt` and configure .bashrc
- [haskell.pl](scripts/haskell.pl): install Haskell packages
- [postgresql.pl](scripts/postgresql.pl): install and configure PostgreSQL (requires sudo and a db username as argument)
- [sublime.pl](scripts/sublime.pl): install Sublime Text Editor for apt or yum ecosystems
