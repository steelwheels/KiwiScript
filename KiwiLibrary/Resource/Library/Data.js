
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

function isInArray2D(array, x, y) {
	let ylen = array.length ;
	if(0 < ylen && 0 <= y && y < ylen){
		let xlen = array[0].length ;
		if(0 < xlen && 0 <= x && x < xlen) {
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
