These are several shell scripts containing aliases, useful functions and tricks
aiming to deliver increased productivity.

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

Then add a call to the main script which does all the magic onto your ``$HOME/.bashrc``:

```bash
$ echo 'source $HOME/bin/bashrc' >> $HOME/.bashrc
```

### Additional tricks

You may find useful to run something _before_ and/or something _after_ you load all scripts
into your terminal session.

To be more specific, my shell scripts and tricks have some dependencies from environment 
variables which may or may not be defined when these scripts are first loaded. If these
environment variables are not loaded, some reasonable defaults are assumed but, given that
you have chance to run things _before_ these scripts are loaded, you have chance to adjust
things as your needs dictate. For example, if you have multiple workspaces, one per customer,
or if you have special WiFi settings depending on the customer you are visiting... well... you
have chance to adjust these details _before_ the scripts are loaded.

#### Actions before loading scripts

Simply create a file named ``$HOME/.bashrc.scripts.before``, as the example below shows:

```bash
#!/bin/bash

function nmcli_connected_wifi {
  nmcli -t -f active,ssid dev wifi | fgrep yes: | cut -d: -f2
}

if [[ "$(nmcli_connected_wifi)" == "MY_CUSTOMERS_WIFI" ]] ;then
  export WORKSPACE=$HOME/Applications/my-customers-development-environment/
  mkdir -p $WORKSPACE > /dev/null
fi
```

#### Actions after loading scripts

Simply create a file named ``$HOME/.bashrc.scripts.after``, as the example below shows:

```bash
#!/bin/bash

if [[ $( nmcli -t -f device,type,state,connection dev | fgrep tun:connected:tun0 ) ]] ;then
  workon hmrc
else
  workon j8s11
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
