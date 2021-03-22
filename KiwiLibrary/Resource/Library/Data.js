/* Data.js */

function Array2D(width, height, value) {
	let result = new Array(height) ;
	for(let i=0 ; i<height ; i++) {
		result[i] = new Array(width).fill(value) ;
	}
	return result ;
}

function isInArray2D(array, x, y) {
	let ylen = array.length ;
	if(0 < ylen && y < ylen){
		let xlen = array[0].length ;
		if(0 < xlen && y < xlen) {
			return true ;
		}
	}
	return false ;
}

function setElementToArray2D(array, x, y, value) {
	if(isInArray2D(array, x, y)){
		array[y][x] = value ;
	}
}

function elementInArray2D(array, x, y) {
	if(isInArray2D(array, x, y)){
		return array[y][x] ;
	} else {
		return null ;
	}
}

