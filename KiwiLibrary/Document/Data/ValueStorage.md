# ValueStorage

## Value storage
The value storage is used for persistent data for the application. In usually, they are loaded and stored by the application automatically.

The [extended JSON](
https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Data/eJSON.md) format is used to store the context of the value storage.

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

The API to access value storage is defined in [ValueStorage class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/ValueStorage.md).

## ValuePath
The value path is used to point the node in the value storage.

### Normal value path
In the next example, The value path `a.b.c` has the value 10.
````
{
  a: {
    b: {
      c: 10             // Pointed by 'a.b.c'
    }
  }
}
````

### Select the array element
You can use indexed path `[n]` to select the element in array. The `n` is positive integer (0, 1, ...).
In the next example, the value path `a.b[1].c` has the value 20.
````
{
  a: {
    b[
      { c: 10 },
      { c: 20 },        // Pointed by 'a.b[1].c'
      { c: 30 }
    ]
  }
}
````

### Select the dictionary element
You can use the indexed path `[k:v]` to select the element in dictionary. The `k` is the property name and the `v` is the value of it.
In the next example, the value path `a.b[c:20]` points the `{ c: 20 }`.

````
{
  a: {
    b[
      { c: 10 },
      { c: 20 },        // Pointed by 'a.b[1].c'
      { c: 30 }
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
* [ValueStorage class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/ValueStorage.md): The API definition to access value storage.
* [Kiwi standard library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): The value storage is defined in this library.
