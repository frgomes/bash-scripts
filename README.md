This is a bunch of shell scripts containing useful functions aiming to deliver increased productivity.

> WARNING: This toolbox is under heavy development. Expect that things change.

See extra documentation: [docs](docs)

## Requirements

* Debian, Ubuntu or openSUSE
* [other distributions?](docs/distros.md) ([contribute](docs/contribute.md)) 
* Python version 3.4+ ([why?](docs/python-venv.md))

## For the impatient

```bash
#!/bin/bash
mkdir -p "$HOME/workspace"
git -C "$HOME/workspace" clone http://github.com/frgomes/bash-scripts
echo 'source $HOME/workspace/bash-scripts/bashrc' >> $HOME/.bashrc
```

Open a new terminal session and enjoy!

## Design Concept

Starting from a brand new laptop with only the base operating system installed, I would like to be able to quickly have my environment setup. Then I open a new terminal window and all remaining bits are automagically configured for me. I also would like to install complex software packages easily, employing just a single command. Then I'm ready to go. The entire thing should not take more than a few minutes.

### Features in a nutshell

* Useful shell scripts aiming daily mundane tasks, such as finding text on large codebases;
* Shell scripts for installing Java, Node, Scala, Rust, among a bunch of other things;
* One [post installation script for sysadmins](docs/postinstall-sysadmin.md) configuring a brand new laptop or server;
* One [post installation script for regular users](docs/postinstall-user.md) seeking Firefox and Thunderbird in user's space;
* Employs [virtual environments](docs/python-venv.md) in order to allow distinct versions of your preferred tools;
* All [commands always available](docs/design.md), no matter if you are using functions, sub-shells or whatever;
* Flexibility of a separate history per session but also a [global history for all sessions](docs/history.md).

### Other use cases

* Opinionated [post installation on system's space](docs/postinstall-sysadmin.md);
* Opinionated [post installation on user's space](docs/postinstall-user.md);

## Additional tricks

### Source your own custom scripts

The initializaton runs scripts matching the pattern: ``$HOME/bin/bash_*.sh``

### Other custom scripts

> This is experimental and requires code review.

More details [here](docs/extensions.md).
