# About KiwiEngine
The *KiwiEngine Framework* is a part of [KiwiScript repository](https://github.com/steelwheels/KiwiScript) on github.
This framework contains primitive data class definitions to support JavaScript execution in JavaScriptCore.

# Copyright
Copyright (C) 2015-2017 [Steel Wheels Project](https://sites.google.com/site/steelwheelsproject/).
This software is distributed under [GNU LESSER GENERAL PUBLIC LICENSE Version 2.1](https://www.gnu.org/licenses/lgpl-2.1-standalone.html).

# Target
* OS: Mac OS X 10.13 or later
* Development Tool: Xcode9 or later

# Specification and Implementation
## `KEContext` class
The *KEContext class* is a subclass of JSContext. It is extended to keep runtime errors while execution.

## `KEPropertyTable` class
The storage to store property values.
The property value (implemented by `KEPropertyValue` class) is independent from JavaScript Context.

## Related link
* [Steel Wheels Project](http://steelwheels.github.io): Web site of developer.
* [KiwiScript](https://github.com/steelwheels/KiwiScript): The repository which contains this framework.
