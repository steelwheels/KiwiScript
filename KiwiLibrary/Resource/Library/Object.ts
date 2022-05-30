/* Object.ts */

/// <reference path="types/Builtin.d.ts"/>
/// <reference path="types/Enum.d.ts"/>

function isEmptyString(str: string): boolean
{
	return (str.length == 0) ;
}

function isEmptyObject(obj: object): boolean
{
	let keys = Object.keys(obj) ;
	return (keys.length == 0) ;
}

