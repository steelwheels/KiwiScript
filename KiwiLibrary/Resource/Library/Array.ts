/* Array.ts */

/// <reference path="types/Builtin.d.ts"/>
/// <reference path="types/Process.d.ts"/>
/// <reference path="types/Enum.d.ts"/>

function first<T>(arr: T[] | null): T | null {
	if(arr != null){
		if(arr.length > 0){
			return arr[0] ;
		}
	}
	return null ;
}

