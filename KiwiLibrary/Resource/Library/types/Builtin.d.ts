/**
 * Builtin.d.ts
 */

interface _Color {
	red:			number ;
	green:			number ;
	blue:			number ;
	alpha:			number ;

        toString():             string ;
}

interface _Console {
	log(message: string): void ;
	print(message: string): void ;
	error(message: string): void ;
}

interface _ColorManager {
        black:          _Color ;
        red:            _Color ;
        green:          _Color ;
        yellow:         _Color ;
        blue:           _Color ;
        magenta:        _Color ;
        cyan:           _Color ;
        white:          _Color ;
}

interface _Curses {
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

interface _Dictionary {
	set(name: string, value: any): void ;
	get(name: string): any | null ;
}

interface _EscapeCode {
        backspace():                    string ;
	delete():                       string ;

	cursorUp(delta: number): string
	cursorDown(delta: number): string
	cursorForward(delta: number): string
	cursorBackward(delta: number): string
	cursorNextLine(delta: number): string
	cursorPreviousLine(delta: number): string
	cursorMoveTo(y: number, x: number): string

	saveCursorPosition(): string
	restoreCursorPosition(): string

	eraceFromCursorToEnd(): string
	eraceFromCursorToBegin(): string
	eraceEntireBuffer(): string
	eraceFromCursorToRight(): string
	eraceFromCursorToLeft(): string
	eraceEntireLine(): string

	scrollUp(lines: number): string
	scrollDown(lines: number): string

	color(type: number, color: number): string
	reset(): string
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
	close(): void ;
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

	setFillColor(col: _Color): void ;
	setStrokeColor(col: _Color): void ;
	setPenSize(size: number): void ;
	moveTo(x: number, y: number): void ;
	lineTo(x: number, y: number): void ;
	circle(x: number, y: number, rad: number): void ;
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

interface _ContactRecord {
	givenName:		string ;
	middleName:		string ;
	familyName:		string ;
}

interface _ContactDatabase {
	recordCount:		number ;
	record(index: number): _ContactRecord ;
	load(callback: (granted: boolean) => void): void ;
}

declare var console:	_Console ;
declare var Color:      _ColorManager ;
declare var Curses:     _Curses ;
declare var EscapeCode: _EscapeCode ;
declare var ExitCode:	_ExitCode ;
declare var FileType:	_FileType ;
declare var _Contacts:	_ContactDatabase ;

declare function Dictionary(): _Dictionary ;
declare function Pipe(): _Pipe ;
declare function Point(x: number, y: number): _Point ;
declare function Rect(x: number, y: number, width: number, height: number): _Rect ;
declare function Size(width: number, height: number): _Size ;

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
declare function isEOF(value: any): boolean ;

declare function asciiCodeName(code: number): string | null ;

declare function sleep(sec: number): boolean ;

declare function _openPanel(title: string, type: number,
					exts: string[], cbfunc: any): void ;
declare function _savePanel(title: string, cbfunc: any): void ;
declare function _run(path: _URL | string, input: _File, output: _File,
					error: _File): object | null ;

