# Dev Environment

I have created a few scripts to setup a development environment.


## Instructions

### Configuration

- add [.gitconfig](config/.gitconfig) to the home directory
- Terminal > Preferences logged bash

### Scripts

```
$ perl <script-name>
```

- [prepare_perl.pl](scripts/prepare_perl.pl): `cpanminus` and basic Perl modules
- [misc.pl](scripts/misc.pl): `clipit`, `htop`, `vim`, `curl`, `git`
- [gitawareprompt.pl](scripts/gitawareprompt.pl): install `git-aware-prompt` and configure .bashrc
- [haskell.pl](scripts/haskell.pl): install Haskell packages
- [postgresql.pl](scripts/postgresql.pl): install and configure PostgreSQL (requires sudo and a db username as argument)
