/* Data.js */

function Array2D(width, height, value) {
	let result = new Array(height) ;
	for(let i=0 ; i<height ; i++) {
		result[i] = new Array(width).fill(value) ;
	}
	return result ;
}
