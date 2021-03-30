This is a bunch of shell scripts containing aliases and useful functions aiming to deliver increased productivity.

> WARNING: This toolbox is under heavy development. Expect that things may change.

## Design Concept

Starting from a brand new laptop with only the base operating system installed, I would like to be able to quickly have my environment setup. I would like to download a shell script from the Internet which sets up everything for me. Then I open a new terminal window and all remaining bits are automagically configured for me. Then I'm ready to go. The entire thing should not take more than a minute or two.

### Features in a nutshell

* Useful shell scripts aiming daily mundane tasks, such as finding text on large codebases;
* Shell scripts for installing Java, Node, Scala, Rust, among a bunch of other things;
* One [post installation script for sysadmins](docs/postinstall-sysadmin.md) configuring a brand new laptop or server;
* One [post installation script for regular users](docs/postinstall-user.md) seeking Firefox and Thunderbird in user's space;
* Employs [virtual environments](docs/python-venv.md) in order to allow distinct versions of your preferred tools;
* All [commands always available](docs/design.md), no matter if you are using functions, sub-shells or whatever;
* Flexibility of a separate history per session but also a [global history for all sessions](docs/history%2B).

## Requirements

* Debian or openSUSE. ([contribute](docs/contribute.md))
* Python version 3.4+ ([why?](docs/python-venv.md))

## For the impatient

This is how I install a powerful set of functions and commands into the shell:

```bash
$ mkdir -p "$HOME/workspace"
$ git -C "$HOME/workspace" clone http://github.com/frgomes/bash-scripts
```

Then add a call to ``$HOME/workspace/bash-scripts/bashrc`` into your ``$HOME/.bashrc``:

```bash
$ echo 'source $HOME/workspace/bash-scripts/bashrc' >> $HOME/.bashrc
```

Open a new terminal session and enjoy!

### Other uses

* Opinionated [post installation on system's space](docs/postinstall-sysadmin.md);
* Opinionated [post installation on user's space](docs/postinstall-user.md);

### Migration Notes

> The migration procedure may be entirely removed if I do not hear from users.

This release performs migration steps if necessary, in a best effort basis, trying to make life easier for users of the previous [legacy branch](https://github.com/frgomes/bash-scripts/tree/legacy). This is why you may see messages such the ones below when you start a new terminal session:

```bash
cp -vp "${HOME}"/.bashrc.scripts.before "${HOME}"/.local/share/bash-scripts/postactivate/head.d/000-default.sh
cp -vp "${HOME}"/.bashrc.scripts.after  "${HOME}"/.local/share/bash-scripts/postactivate/tail.d/999-default.sh
```

## Additional tricks

You may find useful to run something _before_ and/or something _after_ you load [these] scripts
[provided by this package] into your terminal session.

This way, you can define defaults for environment variables before scripts run.
You can also adjust keyboard configurations and other preferences after all scripts run.

More details [here](docs/extensions.md).
