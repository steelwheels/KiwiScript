/*
 * history.js
 */

function main(args)
{
	let i		= 1 ;
	let items	= commandHistory() ;
	for(let item of items){
		stdout.put(i + " " + item + "\n") ;
		i++ ;
	}
	return 0 ;
}
