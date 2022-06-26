/**
 * Builtin.d.ts
 */

interface ColorIF {
	red:			number ;
	green:			number ;
	blue:			number ;
	alpha:			number ;

        toString():             string ;
}

interface ConsoleIF {
	log(message: string): void ;
	print(message: string): void ;
	error(message: string): void ;
}

interface ColorManagerIF {
        black:          ColorIF ;
        red:            ColorIF ;
        green:          ColorIF ;
        yellow:         ColorIF ;
        blue:           ColorIF ;
        magenta:        ColorIF ;
        cyan:           ColorIF ;
        white:          ColorIF ;
}

interface CursesIF {
        minColor:	number ;
        maxColor:       number ;
        black:          number ;
        red:            number ;
        green:          number ;
        yellow:         number ;
        blue:           number ;
        magenta:        number ;
        cyan:           number ;
        white:          number ;

        begin(): void ;
        end(): void ;

        width:                  number ;
        height:                 number ;

        foregroundColor:        number ;
        backgroundColor:        number ;

	moveTo(x: number, y: number): boolean ;
	inkey(): string | null ;

	put(str: string): void ;
	fill(x: number, y: number, width: number, height: number, c: string): void ;
}

interface ArrayIF {
	count:	number ;
	values:	[any] ;

	value(index: number): any | null ;
	contains(value: any): boolean ;
	
	set(value: any, index: number): void ;
	append(value: any): void ;
}

interface SetIF {
	count:	number ;
	values:	[any] ;

	value(index: number): any | null ;
	contains(value: any): boolean ;

	insert(value: any): void ;
}

interface DictionaryIF {
	count:	number ;
	keys:   [any] ;
	values: [any] ;

	set(value: any, name: string): void ;
	value(name: string): any | null ;
}

interface EscapeCodeIF {
        backspace():                    string ;
	delete():                       string ;

	cursorUp(delta: number): string ;
	cursorDown(delta: number): string ;
	cursorForward(delta: number): string ;
	cursorBackward(delta: number): string ;
	cursorNextLine(delta: number): string ;
	cursorPreviousLine(delta: number): string ;
	cursorMoveTo(y: number, x: number): string ;

	saveCursorPosition(): string ;
	restoreCursorPosition(): string ;

	eraceFromCursorToEnd(): string ;
	eraceFromCursorToBegin(): string ;
	eraceEntireBuffer(): string ;
	eraceFromCursorToRight(): string ;
	eraceFromCursorToLeft(): string ;
	eraceEntireLine(): string ;

	scrollUp(lines: number): string ;
	scrollDown(lines: number): string ;

	color(type: number, color: number): string ;
	bold(flag: boolean): string ;

	reset(): string
}

interface FileIF {
	getc(): string ;
	getl(): string ;
	put(str: string): void ;
	close(): void ;
}

interface PipeIF {
        reading:        FileIF ;
        writing:        FileIF ;
}

interface PointIF {
	x : number ;
	y : number ;
}

interface RectIF {
	x:		number ;
	y: 		number ;
	width:		number ;
	height:		number ;
}

interface SizeIF {
	width:		number ;
	height:		number ;
}

interface RangeIF {
	location:	number ;
	length:		number ;
}

interface TextIF
{
        core(): any ;
	toString(): string ;
}

interface TextLineIF extends TextIF
{
        set(str: string): void ;
	append(str: string): void ;
	prepend(str: string): void ;
}

interface TextSectionIF extends TextIF
{
	contentCount: number ;

	add(text: TextIF): void ;
	insert(text: TextIF): void ;
	append(str: string): void ;
	prepend(str: string): void ;
}

interface TextRecordIF extends TextIF
{
        columnCount: number ;
	columns: number ;
        append(str: string): void ;
	prepend(str: string): void ;
}

interface TextTableIF extends TextIF
{
        count: number ;
        records: TextRecordIF[] ;

        add(rec: TextRecordIF): void ;
        inert(rec: TextRecordIF): void ;
	append(str: string): void ;
        prepend(str: string): void ;
}

interface ImageIF {
	size: SizeIF ;
}

/* KLGraphicsContext in swift */
interface GraphicsContextIF {
	logicalFrame:	RectIF ;

	setFillColor(col: ColorIF): void ;
	setStrokeColor(col: ColorIF): void ;
	setPenSize(size: number): void ;
	moveTo(x: number, y: number): void ;
	lineTo(x: number, y: number): void ;
	rect(x: number, y: number, width: number, height: number, dofill: boolean): void ;
	circle(x: number, y: number, rad: number, dofill: boolean): void ;
}

interface BitmapIF
{
	width:		number ;
	height:		number ;

	get(x: number, y: number): ColorIF ;
	set(x: number, y: number, color: ColorIF): void ;
}

interface ProcessIF {
	isRunning:	boolean ;
	didFinished:	boolean ;
	exitCode:	number ;
	terminate(): void ;
}

interface URLIF {
	isNull:			boolean ;
	absoluteString:		string ;
	path:			string ;
	appendingPathComponent(comp: string): URLIF | null ;
	loadText():		string | null ;
}

interface StorageIF {
	value(path: string): any ;

	set(value: any, path: string): boolean ;
	append(value: any, path: string): boolean ;
	delete(path: string): boolean

	save(): boolean ;
	toString(): string ;
}

interface RecordIF {
	fieldNames:		string[] ;

	value(name: string):			any ;
	setValue(value: any, name: string):	boolean ;

	toString(): 		string ;
}

interface PointerValueIF {
	path:			string ;
}

interface TableIF {
	recordCount:		number ;

	readonly defaultFields:	{[name:string]: any} ;

	newRecord():				RecordIF ;
	record(row: number):			RecordIF | null ;
	pointer(value: any, key: string):	PointerValueIF | null ;

	search(value: any, name: string):	RecordIF[] | null ;
	append(record: RecordIF): 		void ;
	appendPointer(pointer: PointerValueIF):	void ;

	remove(index: number):			boolean ;
	save():					boolean ;

	toString(): 		string
}

interface SymbolsIF {
	characterA:		URLIF ;
	chevronBackward:	URLIF ;
	chevronForward:		URLIF ;
	handRaised:		URLIF ;
	line1P:			URLIF ;
	line2P:			URLIF ;
	line4P:			URLIF ;
	line8P:			URLIF ;
	line16P:		URLIF ;
	paintbrush:		URLIF ;
	questionmark:		URLIF ;

	oval(filled: boolean):   URLIF ;
	pencil(filled: boolean): URLIF ;
	rectangle(filled: boolean, rounded: boolean): URLIF ;
}

interface ContactDatabaseIF {
	recordCount:		number ;

	authorize(callback: (granted: boolean) => void): void
	load(url: URLIF | null): boolean ;

	record(index: number): RecordIF | null ;
	search(value: any, name: string):	RecordIF[] | null ;
        append(record: RecordIF): void ;
	forEach(callback: (record: RecordIF) => void): void ;
}

interface CollectionIF {
	sectionCount:			number ;
	itemCount(section: number):	number ;

	header(section: number): string | null ;
	footer(section: number): string | null ;

	value(section: number, item: number): URLIF | null ;
	add(header: string, footer: string, item: URLIF[]): void ;

	toStrings(): string[] ;
}

/* Singleton object*/
declare var console:		ConsoleIF ;
declare var Color:      	ColorManagerIF ;
declare var Curses:     	CursesIF ;
declare var EscapeCode: 	EscapeCodeIF ;
declare var Contacts:	        ContactDatabaseIF ;
declare var Symbols:		SymbolsIF ;

declare function valueType(val: any): number ; // the result defined as enum ValueType

declare function Pipe(): PipeIF ;
declare function Point(x: number, y: number): PointIF ;
declare function Rect(x: number, y: number, width: number, height: number): RectIF ;
declare function Size(width: number, height: number): SizeIF ;
declare function Collection(): CollectionIF ;
declare function URL(path: string): URLIF | null ;

declare function Storage(path: string): StorageIF | null ;
declare function ArrayInStorage(path: string, storage: StorageIF): ArrayIF | null ;
declare function SetInStorage(path: string, storage: StorageIF): SetIF | null ;
declare function DictionaryInStorage(path: string, storage: StorageIF): DictionaryIF | null ;
declare function TableInStorage(path: string, storage: StorageIF): TableIF | null ;

declare function isArray(value: any): boolean ;
declare function isBitmap(value: any): boolean ;
declare function isBoolean(value: any): boolean ;
declare function isDate(value: any): boolean ;
declare function isNull(value: any): boolean ;
declare function isNumber(value: any): boolean ;
declare function isDictionary(value: any): boolean ;
declare function isRecord(value: any): boolean ;
declare function isObject(value: any): boolean ;
declare function isPoint(value: any): boolean ;
declare function isRect(value: any): boolean ;
declare function isSize(value: any): boolean ;
declare function isString(value: any): boolean ;
declare function isUndefined(value: any): boolean ;
declare function isURL(value: any): boolean ;
declare function isEOF(value: any): boolean ;

declare function toArray(value: any): any[] | null ;
declare function toBitmap(value: any): BitmapIF | null ;
declare function toBoolean(value: any): boolean | null ;
declare function toDate(value: any): object | null ;
declare function toNumber(value: any): number | null ;
declare function toDictionary(value: any): {[name:string]: any} | null ;
declare function toRecord(value: any): RecordIF | null ;
declare function toObject(value: any): object | null ;
declare function toPoint(value: any): PointIF | null ;
declare function toRect(value: any): RectIF | null ;
declare function toSize(value: any): SizeIF | null ;
declare function toString(value: any): string | null ;
declare function toURL(value: any): URLIF | null ;
declare function toText(value: any): TextIF ;

declare function asciiCodeName(code: number): string | null ;

declare function exit(code: number): void ;
declare function sleep(sec: number): boolean ;

declare function TextLine(str: string): TextLineIF ;
declare function TextSection(): TextSectionIF ;
declare function TextRecord(): TextRecordIF ;
declare function TextTable(): TextTableIF ;

declare function _openPanel(title: string, type: number,
					exts: string[], cbfunc: any): void ;
declare function _savePanel(title: string, cbfunc: any): void ;
declare function _run(path: URLIF | string, input: FileIF, output: FileIF, error: FileIF): object | null ;

