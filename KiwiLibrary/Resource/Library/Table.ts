/*
 * Primitive data structures
 */

/// <reference path="types/Builtin.d.ts"/>

function valueTableInStorage(storage: string, path: string): ValueTableIF | null
{
        let strg = ValueStorage(storage) ;
        if(strg == null) {
                console.error("[Error] Storage " + storage + " is Not Exist") ;
                return null ;
        }
        return ValueTable(path, strg!) ;

}
