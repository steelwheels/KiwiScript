/* Math.js */

/* randomInt: Get random integer value between min and max */
Math.randomInt = function(min, max) {
  const range = max - min + 1 ;
  const rval  = Math.floor(Math.random() * range) ;
  return rval + min ;
} ;

/* Convert value to integer */
function int(value) {
	return Math.floor(value) ;
}
