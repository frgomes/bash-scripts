## Design Decisions

This toolbox is primary intended to software developers and power users, so that productivity is reclaimed at last for a number of pressing and common activities which usually require a lot of work and/or require some amount of brain activity which could be better employed somewhere else.

 1. **Support for multiple virtual environments**: It must be possible to install tools under a certain virtual environment easily, so that you can easily jump around different projects or different customers without wasting time setting up your tooling for a particular purpose. All which must be required is [Python3 module venv](python-vev.md), which implements the idea of virtual environments.

 2. **Smooth integration with command line tools**: It must be possible to compose commands provided by this toolbox into regular shell scripts, behaving pretty much as the same as other well known commands, keeping the same tenets, behavior and standards adopted by all other well known commands.
 
 3. **Commands must be always ready and visible**: It must always be possible to employ commands provided by this toolbox on the command line, shell scripts or subcommands participating in the command line or shell scripts, in any nested scope as it may be.
 
 4. **Easy of use and well documented**: It should not be necessary to RTFM before use. The functionality of a command should be obvious from its name, as much as possible, and/or every command should provide a help text explaining its function and options.
 
 5. **Self contained**: All commands provided by this toolbox must be responsible for installing its own requirements, freeing the end user of knowing and understanding the inner business employed by the command.

 6. **Lightweight and efficiency**: All commands (or almost all commands!) must be provided as shell scripts, instead of being provided as functions or aliases, so that the shell environment remains lightweight, not being bloated by a bunch of commands which are rarely used. Thanks [@mgunther](http://github.com/mgunther) for raising this important aspect.
 
 7. **Auditing**: It must be possible to track all commands performed in a given terminal session, knowing the date and time they were executed.

 8. **Convenience**:: It must be easy to setup a new laptop, configuring default settings for useful tools.
 
 9. **Roaming**: When visiting multiple customers, you would like to quickly reconfigure your laptop to the customer's local network.
 
10. **Extensions**: The toolbox should provides hooks so that extensions can be easily defined by the user.
