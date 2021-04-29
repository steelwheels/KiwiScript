
/*
 * Primitive data structures
 */

// Allocate 1D array with given size and initial value
function Array1D(length, value){
	let result = new Array(length) ;
	result.fill(value) ;
	return result ;
}

// removeFromArray1D(src: Array<Any>, value: Any) -> Array<Any>
function removeFromArray1D(src, value){
	return src.filter(e => (e != value)) ;
}

// Allocate 1D array with given size and initial value
function Array2D(width, height, value) {
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
	get width()  { return this.mWidth ;  }
	get height() { return this.mHeight ; }

	constructor(width, height){
		this.mWidth	= width ;
		this.mHeight	= height ;
		this.mTable	= Array2D(width, height, null) ;
	}

	isValid(x, y){
		return 0<=x && x<this.mWidth && 0<=y && y<this.mHeight ;
	}

	element(x, y){
		if(this.isValid(x, y)){
			return this.mTable[y][x] ;
		} else {
			return undefined ;
		}
	}

	setElement(x, y, value){
		if(this.isValid(x, y)){
			this.mTable[y][x] = value ;
		}
	}

	fill(value){
		for(let y=0 ; y<this.mHeight ; y++){
			this.mTable[y].fill(value) ;
		}
	}

	// forEarc(func: (value: Any, index: Point, array: Array<Any>, thisArg: this) -> Void)
	forEach(childFunc){
		for(let y=0 ; y<this.mHeight ; y++){
			for(let x=0 ; x<this.mWidth ; x++){
				let value = this.mTable[y][x] ;
				let index = Point(x, y) ;
				let array = this.mTable ;
				childFunc(value, index, array, this) ;
			}
		}
	}

	// forEarchColumn(xpos:Int, func: (value: Any, index: Int) -> Void)
	forEachColumn(x, childFunc){
		if(0<=x && x<this.mWidth){
			return ;
		}
		for(let y=0 ; y<this.mHeight ; y++){
			let value = this.mTable[y][x] ;
			childFunc(value, y) ;
		}
	}

	// forEarchRow(ypos:Int, func: (value: Any, index: Int) -> Void)
	forEachRow(y, childFunc){
		if(0<=y && y<this.mHeight){
			return ;
		}
		for(let x=0 ; x<this.mWidth ; x++){
			let value = this.mTable[y][x] ;
			childFunc(value, x) ;
		}
	}

	find(findFunc){
		for(let y=0 ; y<this.mHeight ; y++){
			for(let x=0 ; x<this.mWidth ; x++){
				let value = this.mTable[y][x] ;
				let index = Point(x, y) ;
				let array = this.mTable ;
				if(findFunc(value, index, array, this)){
					return value ;
				}
			}
		}
		return undefined ;
	}

	findIndex(findFunc){
		for(let y=0 ; y<this.mHeight ; y++){
			for(let x=0 ; x<this.mWidth ; x++){
				let value = this.mTable[y][x] ;
				let index = Point(x, y) ;
				let array = this.mTable ;
				if(findFunc(value, index, array, this)){
					return index ;
				}
			}
		}
		return Point(-1, -1) ;
	}

	// forEarc(func: (value: Any, index: Point, array: Array<Any>, thisArg: this) -> Table)
	map(mapFunc){
		let newtable = new Table(this.mWidth, this.mHeight) ;
		for(let y=0 ; y<this.mHeight ; y++){
			for(let x=0 ; x<this.mWidth ; x++){
				let value  = this.mTable[y][x] ;
				let index  = Point(x, y) ;
				let array  = this.mTable ;
				let newval = mapFunc(value, index, array, this) ;
				newtable.setElement(x, y, newval) ;
			}
		}
		return newtable ;
	}

	// toStrings(elm2str: (element: Any) -> Any)
	toStrings(elm2str){
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
			let str      = `${value}` ;
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

