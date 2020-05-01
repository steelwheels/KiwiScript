/**
 * fonts.js
 */

function main(args)
{
	let names = FontManager.availableFonts ;
	for(let name of names) {
		stdout.put(name + "\n") ;
	}
	return 0 ;
}

