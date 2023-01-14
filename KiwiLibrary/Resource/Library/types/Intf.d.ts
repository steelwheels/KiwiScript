interface FrameCoreIF {
  _value(p0: string): any ;
  _setValue(p0: string, p1: any): boolean ;
  _definePropertyType(p0: string, p1: string): void ;
  _addObserver(p0: string, p1: () => void): void ;
}

interface FrameIF extends FrameCoreIF {
  frameName: string ;
  propertyNames: string[] ;
}

/* Interface declaration: PointIF */
interface PointIF {
	x: number ;
	y: number ;
}
/* Interface declaration: SizeIF */
interface SizeIF {
	height: number ;
	width: number ;
}
/* Interface declaration: RecordIF */
interface RecordIF {
	fieldCount: number ;
	fieldNames: string[] ;
	setValue(p0: any, p1: string): void ;
	value(p0: string): any ;
}
/* Interface declaration: RectIF */
interface RectIF {
	height: number ;
	width: number ;
	x: number ;
	y: number ;
}
/* Interface declaration: RangeIF */
interface RangeIF {
	length: number ;
	location: number ;
}
/* Interface declaration: TableDataIF */
interface TableDataIF extends FrameIF{
	count: number ;
	fieldName(p0: string): string ;
	fieldNames: string[] ;
	newRecord(): RecordIF ;
	record(p0: number): RecordIF ;
	save(): boolean ;
	toString(): string ;
}
