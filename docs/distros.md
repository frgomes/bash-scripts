## Supported distributions

[Community feedback is welcome!](https://github.com/frgomes/bash-scripts/issues/63)

Your [contributions and hacks](docs/contribute.md) are welcome!
 
### Officially supported

> Officially supported distributions are those which are battle tested on a daily basis by any of the key contributors of ``bash-scripts``. To become a key contributor, [contact the author](https://github.com/frgomes/bash-scripts/issues/63) and offer your time and resources in order to promote your beloved distribution to the status of being officially supported.

The distributions below are **officially supported**:

 * Debian Bullseye
 * OpenSUSE Tumbleweed

### Tentatively supported

> Tentatively supported distributions should work fine most of the time, but may eventually contain bugs.

The distributions below are **tentatively supported**:
 
 * Debian Buster and older releases;
 * Ubuntu, Kubuntu and other derivatives;
 * OpenSUSE Leap and other OpenSUSE derivatives;
 * YUM based distributions;
 * DNF based distributions;
 * OPKG based distributions;

### Unsupported

These distributions, operating systems or environments below are unsupported:

 * other Linux distributions not listed above;
 * RPM based distributions;
 * MacOS
 * FreeBSD and other BSD variants
 * Cygwin
 * MinGW
 * others
 
## My distribution is not supported. What should I do?

Adding support for your distribution is simpler than you think. Distribution dependencies are concentrated in only one file: ``apt+``.

The script ``apt+`` is meant to mediate installation of packages, employing the native package manager you have on your distribution, adjusting the name of the package(s) to be installed, if that becomes necessary. In a nutshell, when you call ``apt+``, you are allowed to pass an 'id', a program or a full path:

* id: is an artificial package name which is employed inside ``bash-scripts``.
* program: name of program or executable.
* full path: the full path of any given file

This way, you can simply say ``apt+ install libncurses-dev`` which translates to:

 * Debian: apt install libncurses-dev
 * OpenSUSE: zypper install ncurses-devel

However, you could also say ``apt+ install /usr/include/curses.h``, in case you prefer to pass the full path of a file you are interested.

> Notice that ``apt+`` DOES NOT perform any query against the package repository database at this point, since this functionaly may or may not be available across all distributions and platforms we may be interested to support in future.

When you pass a program name or a full path, ``apt+`` queries some internal tables, organized by supported distribution, in order to find which would be the package offering such program or file.

