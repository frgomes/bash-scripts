These are several shell scripts aiming facilitate installation of applications, utilities, etc.

## For the impatient

### Requirements

Some scripts depend on functions defined at:

* http://github.com/frgomes/debian-bin

### Installation

This is how I install these scripts in my environment:

```bash
$ mkdir $HOME/workspace && cd $HOME/workspace
$ git clone http://github.com/frgomes/debian-scripts

$ cd $HOME
$ ln -s $HOME/workspace/debian-scripts scripts
```
