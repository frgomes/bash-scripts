These are several shell scripts containing aliases, useful functions and tricks
aiming to deliver increased productivity.

**NOTE:** This project is deprecated and kept here for historical reasons only.

----

Please visit http://github.com/frgomes/bash-scripts/ for the new version.

----


## For the impatient

### Installation

This is how I install these scripts in my environment:

```bash
$ mkdir $HOME/workspace && cd $HOME/workspace
$ git clone http://github.com/frgomes/debian-bin

$ cd $HOME
$ mv bin bin.OLD
$ ln -s $HOME/workspace/debian-bin bin
$ source $HOME/bin/bashrc
```

Then add a call to ``$HOME/bin/bashrc`` into your ``$HOME/.bashrc``:

```bash
$ echo 'source $HOME/bin/bashrc' >> $HOME/.bashrc
```

### Additional tricks

You may find useful to run something _before_ and/or something _after_ you load [these] scripts
[provided by this package] into your terminal session.

This way, you can define defauls for environment variables before scripts run.
You can also adjust keyboard configurations and other preferences after all scripts run.

#### Actions before loading scripts

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

#### Actions after loading scripts

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

# see: https://github.com/frgomes/debian-bin/blob/master/virtualenvs/j8s12/bin/postactivate
workon j8s12
```
