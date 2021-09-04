/* ValueEditor.ts */

/// <reference path="types/KiwiLibrary.d.ts"/>
/// <reference path="types/Builtin.d.ts"/>
/// <reference path="types/Readline.d.ts"/>

class ValueEditor
{
        editDictionary(val: {[name: string]: string}): {[name: string]: string} | null {
                let newval = val ;
                let dirty  = false ;
                while(true){
                        /* Make menu items */
                        let items: MenuItem[] = [] ;
                        let keys = Object.keys(newval) ;
                        for(let i=0 ; i<keys.length ; i++){
                                let key = keys[i] ;
                                let item: MenuItem = {key:`${i}`, label: key + " : " + newval[key]} ;
                                items.push(item) ;
                        }
                        /* Add quit menu */
                        let qnum = items.length ;
                        let qitem: MenuItem = {key:`q`, label: "Quit"} ;
                        items.push(qitem) ;
                        /* Output menu */
                        let num = Readline.menu(items) ;
                        if(num == qnum) {
                                return dirty ? newval : null ;
                        } else {
                                /* Edit dictionary element */
                                let key    = keys[num] ;
                                let orgelm = newval[key] ;
                                let newelm = this.editString(orgelm) ;
                                if(newelm != null){
                                        /* Update element */
                                        newval[key] = newelm ;
                                        dirty = true ;
                                }
                        }
                }
                return null ;
        }

        editString(val: string): string | null {
                console.print("current value: \"" + val + "\"\n") ;
                console.print("new value    : ") ;
                let newval = Readline.inputLine() ;
                if(this.checkToReplace()){
                        return newval ;
                } else {
                        return null ;
                }
        }

        checkToReplace(): boolean {
                console.print("Do replace current value ? [y/n] : ") ;
                let ans = Readline.inputLine() ;
                if(ans=="y" || ans=="Y" || ans=="yes" || ans=="YES"){
                        return true ;
                } else {
                        return false ;
                }
        }
}
