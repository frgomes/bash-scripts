This is a bunch of shell scripts for Debian and derivatives containing aliases and useful functions aiming to deliver increased productivity.

WARNING: This toolbox is under heavy development and improvement. Expect that things may change.

### Design Concept

Starting from a brand new laptop with only the base operating system installed, I would like to be able to quickly have my environment setup. I would like to download a shell script from the Internet which sets up everything for me. Then I open a new terminal window and all remaining bits are automagically configured for me. Then I'm ready to go. The entire thing should not take more than a minute or two.

### Features in a nutshell

* Useful shell scripts aiming daily mundane tasks, such as finding text on large codebases;
* Post installation script for sysadmins configuring a brand new laptop or server;
* Post installation script for regular users seeking Firefox and Thunderbird in user's space;
* Shell scripts for installing Java, Node, Rust or Scala, among a bunch of other things.
* Flexibility of a separate history per session but also a global ``history+`` for all sessions.

## For the impatient

### Post-installation scripts for sysadmins

```bash
$ wget https://raw.githubusercontent.com/frgomes/bash-scripts/master/postinstall-sysadmin.sh -O - | bash
```

### Post-installation scripts for regular users
```bash
$ wget https://raw.githubusercontent.com/frgomes/bash-scripts/master/postinstall-user.sh -O - | bash
```

### Integrate powerful commands and aliases into your shell

This is how I install these scripts in my environment:

```bash
$ mkdir -p "$HOME/workspace"
$ git -C  "$HOME/workspace/bash-scripts" clone http://github.com/frgomes/bash-scripts
```

Then add a call to ``$HOME/workspace/bash-scripts/bashrc`` into your ``$HOME/.bashrc``:

```bash
$ echo 'source $HOME/workspace/bash-scripts/bashrc' >> $HOME/.bashrc
```

## Features in more detail

This is just an appetizer of documentation which hopefully is going to land someday.

### Local and global history of previous commands

The well known ``history`` works as usual, i.e.: every terminal session has its own history.

However, there's also a global history available via command ``history+`` which is useful when you have dozens of terminal sessions open and you don't really remember very well where exactly you've typed the command you need. The global history also keeps previous commands organized by date, providing information about the date and time it was typed and the pid of the terminal session which performed it. This is an example:

```bash
$ history+ Software
/home/rgomes/.bash_history+/20200504:16370  1037  2020-05-04 15:39:21 fgfile ' ${Software}/' | cut -d: -f1 | sort | uniq | while read file ;do echo sed 's|$ {Software}/| "${Software}"/|g' -i $file ;done
/home/rgomes/.bash_history+/20200504:16370  1038  2020-05-04 15:39:40 fgfile ' ${Software}/' | cut -d: -f1 | sort | uniq | while read file ;do sed 's|$ {Software}/| "${Software}"/|g' -i $file ;done
```

## Caveats

### Clash between system level and user level Python PIP

The [documentation on Python PIP installation](https://pip.pypa.io/en/stable/installing/) warns that you may have troubles if you've installed ``python-pip`` or ``python3-pip`` using the package manager of your operating system and suddenly you'd like to install Python packages in user's space.

> The best practice is keeping system packages at a minimum and installing all tools in your own user's space. This allows multiple users keep multiple dependencies trees separate, allows a single user keep multiple environments separated and also reduces the exposed [security attack surface](https://en.wikipedia.org/wiki/Attack_surface) of your system.

So, if you are using Python or if you are using [virtual environments](https://realpython.com/python-virtual-environments-a-primer/), please consider uninstalling system packages which are known to cause difficulties to [Python PIP](https://pip.pypa.io) and [Python virtualenv](https://virtualenv.pypa.io). For your convenience, the commands below are known to work on Debian:

```bash
#!/bin/bash
sudo apt remove --purge python-pip python3-pip python-pip-whl python-stevedore virtualenv virtualenv-clone virtualenvwrapper python-virtualenv python-virtualenv-clone python3-virtualenv python2-dev python3-dev -V -s
```

AFTER YOU REVIEW the output of the previous command and you are aware of the consequences of uninstalling these packages and you are sure that you are not going to render your computer unusable, then you can proceed like this:

```bash
#!/bin/bash
sudo apt remove --purge python-pip python3-pip python-pip-whl python-stevedore virtualenv virtualenv-clone virtualenvwrapper python-virtualenv python-virtualenv-clone python3-virtualenv python2-dev python3-dev -y
sudo apt autoremove --purge -y
sudo rm /usr/local/bin/pip{,2,3}
rm $HOME/.local/bin/pip{,2,3}
```

> Note: despite the commands above remove packages ``virtualenv`` and ``virtualenvwrapper``, we install them again but this time, we install under your user, not at system level.


## Additional tricks

You may find useful to run something _before_ and/or something _after_ you load [these] scripts
[provided by this package] into your terminal session.

This way, you can define defauls for environment variables before scripts run.
You can also adjust keyboard configurations and other preferences after all scripts run.

### Actions before loading scripts

Simply create a file named ``$HOME/.bashrc.scripts.before`` and it will be executed before
[these] scripts [provided by this package] run.

This is an example which may be useful if you visit several customers:

```bash
#!/bin/bash

function nmcli_connected_wifi {
  nmcli -t -f active,ssid dev wifi | fgrep yes: | cut -d: -f2
}

#--
# Define environment variable WORKSPACE
# In case I'm connected to "my customer" access point, I'd rather defined it as
# a folder which contains "my customer's" stuff. Otherwise, I simply left undefined.
#--
case "$(nmcli_connected_wifi)" in
  "CUSTOMER_A") export WORKSPACE=$HOME/Documents/customers/CustomerA/
                ;;
  "CUSTOMER_B") export WORKSPACE=$HOME/Documents/customers/CustomerB/
                ;;
  *)            export WORKSPACE=$HOME/workspace
                ;;
esac
```

### Actions after loading scripts

Simply create a file named ``$HOME/.bashrc.scripts.after``, as the example below shows:

```bash
#!/bin/bash

#--
# Select preferences in case a VPN connection is active.
#--
if [[ $( nmcli -t -f device,type,state,connection dev | fgrep tun:connected:tun0 ) ]] ;then
  echo "VPN is active"
fi

#--
# Configure keyboard, depending on which one is connected.
# See also: http://github.com/frgomes/carpalx
#---
if [[ $( lsusb | fgrep 17f6:0905 | fgrep Unicomp ) ]] ;then
  carpalx_hyena_us
elif [[ $( lsusb | fgrep feed:6060 ) ]] ;then
  carpalx_hyena_us
else
  carpalx_hyena_gb
fi
```
