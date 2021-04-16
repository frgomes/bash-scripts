## Overview

> A virtual environment is basically a way to group certain environment variables, functions and programs which are useful for a given task. When you switch to work on a different task, you would like to forget the environment variables, functions and programs you are using right now and you would like to remember new environment variables, functions and programs which will be useful in your next stream of work.

In the old days of Python2, there was a Python package named [virtualenv](https://pypi.org/project/virtualenv/) which helps us create virtual environments and switch between them. With the advent of Python 3.4, part of the funcionality provided by [virtualenv](https://pypi.org/project/virtualenv/) is now available as part of [venv module](https://docs.python.org/3/library/venv.html), which is the solution we use here.

## Support for virtual environments

> Virtual environments are supported via Python3 [venv module](https://docs.python.org/3/library/venv.html).

In the [legacy branch](https://github.com/frgomes/bash-scripts/tree/legacy) we were using [virtualenv](https://pypi.org/project/virtualenv/), which supports Python2.7 and Python3.4+ onwards. However, with Python2 officially deprecated and with a vast quantity of libraries ditching Python2, there's little benefit on using [virtualenv](https://pypi.org/project/virtualenv/) given that [venv module](https://docs.python.org/3/library/venv.html) is already part of Python3.

However, [virtualenv](https://pypi.org/project/virtualenv/) provides some functionality which is not available in [venv module](https://docs.python.org/3/library/venv.html). For this reason, two very common commands are implemented in [our bashrc script](https://github.com/frgomes/bash-scripts/bashrc):

 * mkvirtualenv: creates a new virtualenvironment under ${HOME}/.virtualenvs;
 * workon : activates an existing virtualenv.
 
Examples:

    ### virtual environment for Java 8 with Scala 2.12
    $ mkvirtualenv j8s212
    $ workon j8s212
    $ install_java 8
    $ install_scala 2.12.12
    $ deactivate
    
    ### virtual environment for Java 11 with Scala 2.13
    $ mkvirtualenv j11s213
    $ workon j11s213
    $ install_java 11
    $ install_scala 2.13.5
    $ deactivate

## Legacy: clash between system installed and user installed packages

> This section is only relevant if you are using the [legacy branch](https://github.com/frgomes/bash-scripts/tree/legacy).

Please consider uninstalling system packages which are known to cause difficulties to [Python PIP](https://pip.pypa.io) and [Python virtualenv](https://virtualenv.pypa.io). For your convenience, the commands below are known to work on Debian:

```bash
#!/bin/bash
sudo aptitude remove python-pip python3-pip python-pip-whl python-stevedore virtualenv virtualenv-clone virtualenvwrapper python-virtualenv python-virtualenv-clone python3-virtualenv python2-dev python3-dev -V -s
```

**AFTER YOU REVIEW CAREFULLY** the output of the previous command and you are aware of the consequences of uninstalling these packages and **you are plenty sure that you are not going to render your computer unusable after uninstalling the list of packages you see**, then you can proceed like this:

```bash
#!/bin/bash
sudo aptitude remove python-pip python3-pip python-pip-whl python-stevedore virtualenv virtualenv-clone virtualenvwrapper python-virtualenv python-virtualenv-clone python3-virtualenv python2-dev python3-dev -y
sudo rm /usr/local/bin/pip{,2,3}
rm $HOME/.local/bin/pip{,2,3}
```
