This is a bunch of shell scripts containing useful functions aiming to deliver increased productivity.

> WARNING: This toolbox is under heavy development. Expect that things change.

See documentation: [docs](docs)


## Quick demo

```bash
source ~/workspace/bash-scripts/bin/bashrc  ## see installation procedure below
install_local_bin_uv                        ## installs uv for the first time into your ~/.local/bin
uv python 3.14                              ## installs Python 3.14 managed by uv

mkdir myapp
cd myapp

## create virtual environment
uv venv --python 3.14 --seed --managed-python

## install Node into virtual environment
install_node 24.18.0

## activate virtual environment
source .venv/bin/activate && postactivate

## verify installed tools
python3 --version             # 3.14
node --version                # 24.18.0
```


## Requirements

* Debian or Ubuntu or openSUSE or Fedora or [maybe your preferred distribution?](docs/distros.md) ([contribute](docs/contribute.md)) 
* Python3 version 3.4+ ([why?](docs/python-venv.md))

## For the impatient

> WARNING: **Make sure you have two or more terminal window open** so that you can fix mistakes in case your ``.bashrc`` kicks you out next time you log in.

```bash
#!/usr/bin/env sh
[ -d "${HOME}/workspace" ] || mkdir -p "${HOME}/workspace"
[ -d "${HOME}/workspace/bash-scripts" ] || git -C "${HOME}/workspace" clone http://github.com/frgomes/bash-scripts
echo 'source ${HOME}/workspace/bash-scripts/bashrc ## http://github.com/frgomes/bash-scripts' >> ${HOME}/.bashrc
```

Open a new terminal session and enjoy!

## For the experienced and impatient

    curl -s https://raw.githubusercontent.com/frgomes/bash-scripts/master/unsafe/bashrc-up | bash


## Design Concept

Starting from a brand new laptop with only the base operating system installed, I would like to be able to quickly have my environment setup. Then I open a new terminal window and all remaining bits are automagically configured for me. I also would like to install complex software packages easily, employing just a single command. Then I'm ready to go. The entire thing should not take more than a few minutes.

### Features in a nutshell

* Useful shell scripts aiming daily mundane tasks, such as finding text on large codebases;
* Shell scripts for installing Java, Node, Scala, Rust, among a bunch of other things;
* All [commands always available](docs/design.md), no matter if you are using functions, sub-shells or whatever;
* Flexibility of a separate history per session but also a [global history for all sessions](docs/history.md).
