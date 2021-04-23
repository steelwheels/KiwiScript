
/*
 * Primitive data structures
 */
function Array1D(length, value){
	let result = new Array(length) ;
	result.fill(value) ;
	return result ;
}

// FillArray1D(dst: Array, value: object)
function fillArray1D(dst, value){
	dst.fill(value) ;
}

function Array2D(width, height, value) {
	let result = new Array(height) ;
	for(let i=0 ; i<height ; i++) {
		result[i] = new Array(width).fill(value) ;
	}
	return result ;
}

// FillArray2D(dst: Array, value: object)
function fillArray2D(dst, value){
	for(let i=0 ; i<dst.length ; i++){
		dst[i].fill(value) ;
	}
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
