## Local and global history of previous commands

The well known ``history`` works as usual, i.e.: every terminal session has its own history.

However, there's also a global history available via command ``history+`` which is useful when you have dozens of terminal sessions open and you don't really remember very well where exactly you've typed the command you need. The global history also keeps previous commands organized by date, providing information about the date and time it was typed and the pid of the terminal session which performed it. This is an example:

```bash
$ history+ Software
/home/rgomes/.bash_history+/20200504:16370  1038  2020-05-04 15:39:40 frg sh Software | cut -d: -f1 | sort | uniq | while read file ;do sed 's|$ {Software}/| "${Software}"/|g' -i $file ;done
```
