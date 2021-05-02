/*
 * Primitive data structures
 */

/// <reference path="types/Builtin.d.ts"/>

function Array1D(length: number, value: any): any[] {
	let result = new Array(length) ;
	result.fill(value) ;
	return result ;
}

function Array2D(width: number, height: number, value: any): any[][] {
	let result = new Array(height) ;
	for(let i=0 ; i<height ; i++) {
		result[i] = new Array(width).fill(value) ;
	}
	return result ;
}

/*
 * Table class
 */
class Table
{
        mWidth:         number ;
        mHeight:        number ;
        mTable:         any[][] ;

	get width():  number { return this.mWidth ;  }
	get height(): number { return this.mHeight ; }

	constructor(width: number, height: number){
		this.mWidth	= width ;
		this.mHeight	= height ;
		this.mTable	= Array2D(width, height, null) ;
	}

	isValid(x:number, y:number): boolean {
		return 0<=x && x<this.mWidth && 0<=y && y<this.mHeight ;
	}

	element(x: number, y: number): any | null | undefined {
		if(this.isValid(x, y)){
			return this.mTable[y][x] ;
		} else {
			return undefined ;
		}
	}

	setElement(x: number, y: number, value: any | null){
		if(this.isValid(x, y)){
			this.mTable[y][x] = value ;
		}
	}

	fill(value: any | null): void {
		for(let y=0 ; y<this.mHeight ; y++){
			this.mTable[y].fill(value) ;
		}
	}

	forEach(childFunc: (value: any, index: _Point) => void): void {
		for(let y=0 ; y<this.mHeight ; y++){
			for(let x=0 ; x<this.mWidth ; x++){
				let value = this.mTable[y][x] ;
				let index = Point(x, y) ;
				childFunc(value, index) ;
			}
		}
	}

	forEachColumn(x: number, childFunc: (value:any, y:number) => void): void {
		if(0<=x && x<this.mWidth){
			for(let y=0 ; y<this.mHeight ; y++){
                                let value = this.mTable[y][x] ;
                                childFunc(value, y) ;
                        }
		}
	}

	forEachRow(y: number , childFunc: (value:any, x:number) => void): void {
		if(0<=y && y<this.mHeight){
			for(let x=0 ; x<this.mWidth ; x++){
                                let value = this.mTable[y][x] ;
                                childFunc(value, x) ;
                        }
		}
	}

	find(findFunc: (value: any, index: _Point) => boolean): void {
		for(let y=0 ; y<this.mHeight ; y++){
			for(let x=0 ; x<this.mWidth ; x++){
				let value = this.mTable[y][x] ;
				let index = Point(x, y) ;
				if(findFunc(value, index)){
					return value ;
				}
			}
		}
		return undefined ;
	}

	findIndex(findFunc: (value: any, index: _Point) => boolean): _Point {
		for(let y=0 ; y<this.mHeight ; y++){
			for(let x=0 ; x<this.mWidth ; x++){
				let value = this.mTable[y][x] ;
				let index = Point(x, y) ;
				if(findFunc(value, index)){
					return index ;
				}
			}
		}
		return Point(-1, -1) ;
	}

	map(mapFunc: (value: any, index: _Point) => any): Table {
		let newtable = new Table(this.mWidth, this.mHeight) ;
		for(let y=0 ; y<this.mHeight ; y++){
			for(let x=0 ; x<this.mWidth ; x++){
				let value  = this.mTable[y][x] ;
				let index  = Point(x, y) ;
				let newval = mapFunc(value, index) ;
				newtable.setElement(x, y, newval) ;
			}
		}
		return newtable ;
	}

	toStrings(elm2str: (value: any, index: _Point) => any): string[] {
		let strtable  = this.map(elm2str) ;
		let maxwidths = Array1D(this.mWidth, 0) ;

		/* Get max column widths */
		for(let x=0 ; x<this.mWidth ; x++){
			let maxwidth = 0 ;
			strtable.forEachColumn(x, function(v){
				if(isString(v)){
					maxwidth = Math.max(maxwidth, v.length) ;
				}
			}) ;
			maxwidths[x] = maxwidth ;
		}

		/* Adjust each width */
		let adjtable = strtable.map(function(value, index){
			let str: string = `${value}` ;
			let maxwidth = maxwidths[index.x] ;
			if(str.length < maxwidth){
				str.padEnd(maxwidth - str.length) ;
			} 
			return str ;
		}) ;

		/* Connect row elements into a line */
		let result = [] ;
		for(let y=0 ; y<this.mHeight ; y++){
			let line  = "" ;
			let space = "" ;
			for(let x=0 ; x<this.mWidth ; x++){
				line += space + adjtable.element(x, y) ;
				space =  " " ;
			}
			result.push(line) ;
		}
		return result ;
	}
}

