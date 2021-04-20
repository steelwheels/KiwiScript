/**
 * Terminal.js
 */

class TerminalManager
{
        // menu(items: Array<String>) -> Int
        menu(items) {
                let result  = 0 ;
                let decided = false ;
                while(!decided){
                        for(let i=0 ; i<items.length ; i++){
                                console.print(`${i}: ${items[i]}\n`) ;
                        }
			console.print("number> ") ;
			let line = null ;
			while(line == null){
				line = Readline.input() ;
			}
			console.print("\n") ; // insert newline after the input
                        let num  = parseInt(line) ;
                        if(!isNaN(num)){
                                if(0<=num && num<items.length){
                                        result  = num ;
                                        decided = true; 
                                } else {
                                        console.error(`[Error] Unexpected value: ${num}\n`) ;
                                }
                        } else {
                                console.error(`[Error] Not number value: ${line}\n`) ;
                        }
                }
                return result ;
        }
}

const Terminal = new TerminalManager() ;
