# ContactTable

The ContactTable class wraps the [Contacts](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Contacts.md) database. 
It support the interface to be used in the [Table Component](https://github.com/steelwheels/KiwiCompnents/blob/master/Document/Components/Table.md).

You must call [setupContactTable](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/SetupContactTable.md) function and check the result before accessing `Contacts` object.

## Global variable
The instance of ContactTable class. It is singleton object.

|Variable    |Class      | Description                   |
|:---        |:---       |:---                           |
|`ContactTable`  |ContactTableIF |Singleton object of the class  |

## Properties
### columnCount
````
columnCount:		number ;
````

### rowCount
````
rowCount:		number ;
````

## Methods
### title
````
title(index: number): String ;
````

### setTitle
````
setTitle(index: number, title: string): void ;
````

### value
````
value(cidx: number, ridx: number): string ;
````

### setValue
````
setValue(cidx: number, ridx: number, value: string): void ;
````

### load
````
load(callback: (granted: boolean) => void): void ;
````

# Reference
* [setupContactTable](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/SetupContactTable.md): The function to setup the contact database
* [KiwiStandardLibrary](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Builtin data/function and classes.
