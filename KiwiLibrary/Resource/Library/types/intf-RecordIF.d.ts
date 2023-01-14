/* Interface declaration: RecordIF */
interface RecordIF {
	fieldCount: number ;
	fieldNames: string[] ;
	setValue(p0: any, p1: string): void ;
	value(p0: string): any ;
}
