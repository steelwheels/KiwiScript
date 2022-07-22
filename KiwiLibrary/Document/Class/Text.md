# Text classes

## Text Interface
````
interface TextIF
{
        core(): any ;
        toStrings(idx: number): string[] ;
}
````

### Class: `TextLine`
````
interface TextLineIF extends TextIF
{
        set(str: string): void ;
        append(str: string): void ;
        prepend(str: string): void ;
}
````

### Class: `TextSection`
````
interface TextSectionIF extends TextIF
{
        contentCount: number ;

        add(text: TextIF): void ;
        insert(text: TextIF): void ;
        append(str: string): void ;
        prepend(str: string): void ;
}
````

### Class: `TextRecord`
````
interface TextRecordIF extends TextIF
{
        columnCount: number ;
        columns: number ;

        append(str: string): void ;
        prepend(str: string): void ;
}
````

### Class `TextTable`
````
interface TextTableIF extends TextIF
{
        count: number ;
        records: TextRecordIF[] ;

        add(rec: TextRecordIF): void ;
        inert(rec: TextRecordIF): void ;
        append(str: string): void ;
        prepend(str: string): void ;
}
````

# Reference
* [Kiwi Standard Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): The library which contains this class.
