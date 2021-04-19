# Functions for `String` operations

## `maxLengthOfStrings`
````
maxLengthOfString(strs: Array<String>) -> Int
````

## `adjustLengthOfStrings`
````
adjustLengthOfStrings(strs: Array<String>) -> Array<String>
````

## `pasteStrings`
This function arranges two array of strings horizontally. Each array of strings are adjusted to have same length. The `space` string is placed between the string in `src0` and `src1` .
````
pasteStrings(src0: Array<String>, src1: Array<String>, space: String) -> Array<String>
````
This is the example of the output of the function.
````
let src0 = ["a", "bc", "def"] ;
let src1 = ["1234", "567"] ;
let dst0 = pasteStrings(src0, src1, "-") ;

dst0 == ["a  -1234",
         "bc -567 ",
         "def-    "]
````
