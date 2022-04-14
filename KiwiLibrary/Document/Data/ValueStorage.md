# ValueStorage

## ValuePath
### Normal
````
a.b.c
````

### Reference by ID
The only 1st memeber can be pointer by ID.
````
@id.a.b.c
````

### Select element of array
````
x.a[10].x
````

### Select element of dictionary
````
x.a[key].x
````
Is it not different from
````
x.a.key.x
````

### Select dictionary in array
````
x.a[key:value].x
````
