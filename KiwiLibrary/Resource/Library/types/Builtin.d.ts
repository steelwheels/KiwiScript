/**
 * Builtin.d.ts
 */

interface _Color {
	red:			number ;
	green:			number ;
	blue:			number ;
	alpha:			number ;
}

interface _Console {
	log(message: string): void ;
	print(message: string): void ;
	error(message: string): void ;
}

interface _Dictionary {
	set(name: string, value: any): void ;
	get(name: string): any | null ;
}

interface _ExitCode {
	noError:		number ;
	internalError:		number ;
	commaneLineError:	number ;
	syntaxError:		number ;
	exception:		number ;
}

interface _File {
	getc(): string ;
	getl(): string ;
	put(str: string): void ;
}

interface _FileType {
	notExist:	number ;
	file:		number ;
	directory:	number ;
}

interface _Pipe {
        reading:        _File ;
        writing:        _File ;
}

interface _Point {
	x : number ;
	y : number ;
} 

interface _Rect {
	x:		number ;
	y: 		number ;
	width:		number ;
	height:		number ;
} 

interface _Size {
	width:		number ;
	height:		number ;
}

/* KLGraphicsContext in swift */
interface _GraphicsContext {
	logicalFrame:	_Rect ;

	setFillColor(col: _Color) ;
	setStrokeColor(col: _Color) ;
	setPenSize(size: number) ;
	moveTo(x: number, y: number) ;
	lineTo(x: number, y: number) ;
	circle(x: number, y: number, rad: number) ;
}

interface _Process {
	isRunning:	boolean ;
	didFinished:	boolean ;
	exitCode:	number ;
	terminate(): void ;
}

interface _URL {
	isNull:			boolean ;
	absoluteString:		string ;
	path:			string ;
	appendingPathComponent(comp: string): _URL | null ;
	loadText():		string | null ;
}

declare var console:	_Console ;
declare var ExitCode:	_ExitCode ;
declare var FileType:	_FileType ;

declare function Dictionary(): _Dictionary ;
declare function Pipe(): _Pipe ;
declare function Point(x: number, y: number): _Point ;

declare function isArray(value: any): boolean ;
declare function isBitmap(value: any): boolean ;
declare function isBoolean(value: any): boolean ;
declare function isDate(value: any): boolean ;
declare function isNull(value: any): boolean ;
declare function isNumber(value: any): boolean ;
declare function isObject(value: any): boolean ;
declare function isPoint(value: any): boolean ;
declare function isRect(value: any): boolean ;
declare function isSize(value: any): boolean ;
declare function isString(value: any): boolean ;
declare function isUndefined(value: any): boolean ;
declare function isURL(value: any): boolean ;

declare function sleep(sec: number) ;

declare function _openPanel(title: string, type: number,
					exts: string[], cbfunc: any) ;
declare function _run(path: _URL | string, input: _File, output: _File,
					error: _File) ;

