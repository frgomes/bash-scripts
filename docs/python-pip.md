## Best practices on usage of python-pip

The [documentation on Python PIP installation](https://pip.pypa.io/en/stable/installing/) warns that you may have troubles if you've installed ``python-pip`` using the package manager of your operating system and suddenly you'd like to install Python packages in user's space.

> The best practice is keeping system packages at a minimum and installing all tools in your own user's space. This allows multiple users keep multiple dependencies trees separate, allows a single user keep multiple environments separated and also reduces the exposed [security attack surface](https://en.wikipedia.org/wiki/Attack_surface) of your system.
