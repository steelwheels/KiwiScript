# The file format for `Storage`

The value storage is used to load (or store) persistent data for the application. In usually, the path of storage file is declared in [manifest file](https://github.com/steelwheels/JSTools/blob/master/Document/jspkg.md). The file is loaded when the storage access is detected.

The [extended JSON](
https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Format/eJSONFormat.md) format is used to store the context of the value storage.

This is a sample file of the value storage:
````
{
  id:             "sample_table",       // *1
  class:          "Table",
  columnNames:    ["c0", "c1", "c2"],
  records: [
    {
      c0:  0,
      c1:  1,
      c2:  2
    },
    {
      c0: 10,
      c1: 11,
      c2: 12
    },
    {
      c0: 20,
      c1: 21,
      c2: 22
    }
  ]
}
````

The `id` property will have special meaning.
The value of the `id` property must have *string type* and they must be unique in a storage.
Because the `id` is used to identify the node in storage (See the section *ValuePath*).

The API to access value storage is defined in [Storage class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/ValueStorage.md).

## ValuePath

The value path is defined in the pointer class. It is used to point the nocde in the value storage:
````
{
        pointer: {
                class: "pointer",
                path:  "<path>"
        }
}
````

### Normal path
In the next example, The value path `"a.b.c"` points the property `"c"` which has value 10.
````
{
  a: {
    b: {
      c: 10             // Pointed by "a.b.c"
    }
  }
}
````

### Array element path
You can use indexed path `[n]` to select the element in array. The `n` is positive integer (0, 1, ...).
In the next example, the value path `a.b[1].c` points the property `"c"` which has value 20.
````
{
  a: {
    b: [
      { c: 10 },
      { c: 20 },        // Pointed by 'a.b[1].c'
      { c: 30 }
    ]
  }
}
````

### Select by key and value
You can use the indexed path `[k=v]` to select the array element. The `k` is the property name and the `v` is the value of it.
In the next example, the value path `a.b[c1=20]` points the 2nd element in `b` array.

````
{
  a: {
    b: [
      {c0: 10, d0:"v0"},
      {c1: 20, d1:"v1"},  // Pointed by "a.b[c1=20]"
      {c2: 40, d2:"v2"}   // Pointer by "a.b[d2:\"v2\"]"
    ]
  }
}
````

### Reference by ID
You can define the relative path against ID node.
In the next example, the value path `@id0.c[0].d` has the value 20.
````
{
  a: {
    b: {
      id: "id0",
      c: [
        { d: 10 },
        { d: 20 },        // Pointed by '@id0.c[0].d'
        { d: 30 }
      ]
    }
  }
}
````

# References
* [Storage class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/ValueStorage.md): The API definition to access value storage.
* [Kiwi standard library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): The value storage is defined in this library.
