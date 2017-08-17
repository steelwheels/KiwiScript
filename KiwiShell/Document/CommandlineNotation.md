# Canary Command line Notation
## Introduction
The *Canary Command Line Notation* defines the notation to present parameters of command line tools (such as Unit shell commands).

The  notation is defined by [JSON](http://www.json.org).

## Copyright
Copyright (C) 2017 [Steel Wheels Project](http://steelwheels.github.io). This document distributed under
[GNU Free Documentation License](https://www.gnu.org/licenses/fdl-1.3.en.html).

## Related links
- [Mac OS X Manual Pages](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/) at Apple

## Command Line Notation
### Common notation
The object to execute shell command. This contains information contains
command name and parameters to execute it.
````
{
  "command": "command-name",
              // type: String
              // The name of the shell command
              // (Name only, path is not required)
  "parameters": {
    ...       // the context of parameters are defined
              // for each shell commands.
  }
}
````

### rsync command parameters
Now, the rsync command is used synchronize the destination directory
by the source directory. The destination directory will have
same contents with source.
````
"parameters": {
  "source"      : source-directory-path,
  "destination" : destination-directory-path
}
````
