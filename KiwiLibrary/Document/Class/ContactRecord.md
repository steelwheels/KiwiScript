# ContactRecord class
The database record which is managed by [Contacts](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Contacts.md) database.

## Properties

|Name          |Type           |Description                     |
|:--            |:--            |:--   |
|fieldCount     |number         |Number of fiels in record     |
|fielaNames     |string[]       |Array of filed names. The size is presented by `fieldCount`    |
|givenName      |string \| null  |The given name  |
|middleName	|string \| null  |The middle name |
|familyName     |string \| null  |The family name |
|jobTitle       |string \| null  |Title of the job |
|organizationName |string \|null |Name of organization |
|departmentName |string \| null  |Name of department |
|postalAddresses |{[name:string]: string} \| null |Multi kind postal addresses. The key is the kind of postal addresses |
|emailAddresses |{[name:string]: string} \| null |Multi kind e-mail addresses. The key is the kind of e-mail |
|urlAddresses |{[name:string]: string} \| null |Multi kind URL addresses. The key is the kind of URL |

## Methods
### `value`
Get value for given field.
```
value(name: string): any ;
```

### `setValue`
Set value to given field.
````
setValue(val: any, name: string): boolean ;
````

# Reference
* [Contacts](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Contacts.md): The database which operate CotactRecord.
* [setupContacts](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/TypeChecks.md): The function to setup the contact database
* [KiwiStandardLibrary](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Builtin data/function and classes.
