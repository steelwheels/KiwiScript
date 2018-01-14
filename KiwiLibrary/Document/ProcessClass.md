# Process Operation
The singleton object to control the application process.

## Global variables
Following global variables are defined when this class is imported.

|Variable   |Class   | Description                     |
|:---       |:---    |:---                             |
|Process    |Process | Singleton object of Process class  |

## Process Class
### `execute` class method
Create sub process to execute given command. The parameters for callback functions are used to connect the command with pipe stream.
````
  Process.execute(command, stdincb, stdoutcb, stderrcb)
````
#### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|command      |String |Command and arguments to execute on shell|
|stdincb      | func() -> String? |Callback to give input string to standard input of the sub process|
|stdoutcb     | func(String) |Callback to get output string from standard output|
|stderrcb     | func(String) |Callback to get output string from standard error|
If you pass *null* to callback parameters, the default input/output pipe is used to connect with sub process.

#### Return value
The integer value which is returned by the sub process is returned.

### `exit` class method
Terminate process by the given exit code.
````
  Process.exit(<exit-code>)
````
#### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|exit-code    |Int    |The path of the file to access.|

#### Return value
None
