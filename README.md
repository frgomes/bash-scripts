These are several shell scripts containing aliases, useful functions and tricks aiming to deliver increased productivity.

Shell scripts are definitely tested in Debian. Support CentOS is done on a best effort basis.


### Features in a nutshell

* Useful shell scripts mainly aiming daily mundane tasks, such as finding text on large codebases;
* Useful post installation scripts, when a sysadmin is configuring a brand new laptop or server;
* Useful installation scripts, when a regular user is installing Java, Node, Rust or Scala, among a bunch of other things.


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
$ mkdir $HOME/workspace && cd $HOME/workspace
$ git clone http://github.com/frgomes/bash-scripts
```

Then add a call to ``$HOME/workspace/bash-scripts/bashrc`` into your ``$HOME/.bashrc``:

```bash
$ echo 'source $HOME/workspace/bash-scripts/bashrc' >> $HOME/.bashrc
```

## Caveats

### Clash between system level and user level Python PIP

The [documentation on Python PIP installation](https://pip.pypa.io/en/stable/installing/) warns that you may have troubles if you've installed ``python-pip`` or ``python3-pip`` using the package manager of your operating system and suddenly you'd like to install Python packages at user level.

> The best practice is keeping system packages at a minimum and installing all tools at system level. This allows multiple users keep multiple dependencies trees separate, allows a single user keep multiple environments separated and also reduces the exposed [security attack surface](https://en.wikipedia.org/wiki/Attack_surface) of your system.

So, if you are using Python or if you are using virtual environments, please consider uninstalling system packages which are known to cause difficulties to [Python PIP](https://pip.pypa.io) and [Python virtualenv](https://virtualenv.pypa.io). For your convenience, the commands below are known to work on Debian:

```bash
sudo apt remove --purge python-pip python3-pip python-pip-whl python-stevedore virtualenv virtualenv-clone virtualenvwrapper python-virtualenv python-virtualenv-clone python3-virtualenv -y
sudo apt autoremove --purge -y
sudo rm /usr/local/bin/pip{,2,3}
rm $HOME/.local/bin/pip{,2,3}
```

> Note: despite the commands above remove packages ``virtualenv`` and ``virtualenvwrapper``, we offer a replacement for function ``workon``. So, even though you are removing these packages from your system, you will still be able to use ``workon`` as usual.

## Additional tricks

You may find useful to run something _before_ and/or something _after_ you load [these] scripts
[provided by this package] into your terminal session.

This way, you can define defauls for environment variables before scripts run.
You can also adjust keyboard configurations and other preferences after all scripts run.

### Actions before loading scripts

Simply create a file named ``$HOME/.bashrc.scripts.before`` and it will be executed before
[these] scripts [provided by this package] run.

This is an example which may be useful if you visit several clients:

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
  *)            export WORKSPACR=$HOME/workspace
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

# see: https://github.com/frgomes/bash-scripts/blob/master/bashrc-virtualenvs/p3j8s12/bin/postactivate
workon p3j8s12
```
