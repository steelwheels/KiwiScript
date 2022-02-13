/*
 * Readline.ts
 */

/// <reference path="types/KiwiLibrary.d.ts"/>
/// <reference path="types/Builtin.d.ts"/>

type MenuItem = {
        key:            string ;
        label:          string ;
} ;

class ReadlineObject
{
	constructor(){
	}

	inputLine(): string {
		let line: string | null = null ;
		while(line == null){
			line = _readlineCore.input() ;
			sleep(0.1) ;
		}
		console.print("\n") ; // insert newline after the input
		return line ;
	}

	inputInteger(): number {
		let result: number | null = null ;
		while(result == null){
			let line = this.inputLine() ;
			let val  = parseInt(line) ;
			if(!isNaN(val)){
				result = val ;
			}
		}
		return result ;
	}

	menu(items: MenuItem[]): number {
		let result  = 0 ;
		let decided = false ;
		while(!decided){
			this.printMenu(items) ;
			console.print("item> ") ;
			let line = Readline.inputLine() ;

                        for(let i=0 ; i<items.length ; i++){
                                let item = items[i] ;
                                if(isEqualTrimmedStrings(item.key, line)){
                                        result  = i ;
                                        decided = true ;
                                }
                        }
                        if(!decided){
                                console.print("Unacceptable input\n") ;
                         }
		}
		return result ;
	}

        printMenu(items: MenuItem[]){
                let table = TextTable() ;
                for(let item of items){
                        let record = TextRecord() ;
                        record.append(item.key) ;
			record.append(":") ;
                        record.append(item.label) ;
                        table.add(record) ;
                }
                let line = table.toString() ;
		console.print(line + "\n") ;
        }

        stringsToMenuItems(labels: string[], doescape: boolean): MenuItem[] {
                let result: MenuItem[] = [] ;
                for(let i=0 ; i<labels.length ; i++){
                        let item: MenuItem = {key: `${i}`, label: labels[i]} ;
                        result.push(item) ;
                }
                if(doescape){
                        let item: MenuItem = {key: "q", label: "Quit"} ;
                        result.push(item) ;
                }
                return result ;
        }
}

const Readline = new ReadlineObject() ;

