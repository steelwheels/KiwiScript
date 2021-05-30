# Panel functions
This document describes about panel functions.

# Functions
## `openPanel` function
````
var url = openPanel(title, type, [extensions]) ;
````
### Parameters
|Name     |Type     |Description              |
|:---     |:---     |:---                     |
|title    |string   |Title of the panel       |
|type     |[FileType](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/FileType.md) |File type: directory or file |
|extensions |Array of string | Array of file extensions |

### Return value
|Type     |Description              |
|:---     |:---                     |
|URL      |Selected file or directory |
|null     |Use does not select the file or directory  |

## `savePanel` function
````
var url = savePanel(title) ;
````
### Parameters
|Name     |Type     |Description              |
|:---     |:---     |:---                     |
|title    |string   |Title of the panel       |

### Return value
|Type     |Description              |
|:---     |:---                     |
|URL      |Selected file or directory |
|null     |Use does not select the file or directory  |

## References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library

