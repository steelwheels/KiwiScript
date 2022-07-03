/* Math.ts */

/// <reference path="types/Builtin.d.ts"/>
/// <reference path="types/Enum.d.ts"/>

interface Math {
	randomInt(min: number, max: number): number ;
	clamp(src: number, min: number, max: number): number ;
} ;

/* Convert value to integer */
function int(value: number): number {
	return Math.floor(value) ;
}

/* randomInt: Get random integer value between min and max */
Math.randomInt = function(min: number, max: number): number {
  const range = max - min + 1 ;
  const rval  = Math.floor(Math.random() * range) ;
  return rval + min ;
} ;

/* clamp: Clip the source value with minimum/maximum value */
Math.clamp = function(src: number, min: number, max: number): number {
	if(src < min){
		return min;
	} else if(src > max) {
		return max ;
	} else {
		return src ;
	}
} ;

function compareNumbers(n0:number, n1:number): ComparisonResult
{
	if(n0 < n1){
		return ComparisonResult.ascending ;
	} else if(n0 == n1) {
		return ComparisonResult.same ;
	} else {
		return ComparisonResult.descending ;
	}
}

function compareStrings(s0:string, s1:string): ComparisonResult
{
	if(s0 < s1){
		return ComparisonResult.ascending ;
	} else if(s0 == s1) {
		return ComparisonResult.same ;
	} else {
		return ComparisonResult.descending ;
	}
}

