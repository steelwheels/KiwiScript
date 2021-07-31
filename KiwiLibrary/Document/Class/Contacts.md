# Contacts

You must call [setupContacts](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/SetupContacts.md) function and check the result before accessing `Contacts` object.

This class accesses *ContactRecord* which presents the record of contact database. The contact record is implemented by [ContactRecord](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/ContactRecord.md) class.

## Global variable
The instance of Contacts class. It is singleton object.

|Variable    |Class      | Description                   |
|:---        |:---       |:---                           |
|`Contacts`  |ContactsIF |Singleton object of the class  |

## Properties
### recordCount
````
recordCount: number
````
Get the number of records in contacts database.

## Methods
### record
Get contact record by the index. If the record is NOT found, the return value will be `null`.
````
record(index: number): ContactRecordIf | null
````

### append 
````
append(record: ContactRecordIF): void
````

### forEach
````
forEach(callback: (record: ContactRecordIF) => void): void
````

### load
````
load(callback: (granted: boolean) => void): void
````

# Reference
* [ContactRecord](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/ContactRecord.md): The record of contact database
* [setupContacts](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/SetupContacts.md): The function to setup the contact database
* [KiwiStandardLibrary](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Builtin data/function and classes.

