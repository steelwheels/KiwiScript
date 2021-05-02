/**
 * Builtin.d.ts
 */

interface _ReadlineCore {
	input():	string | null ;
	history():	string[] ;
}

declare var _readlineCore:	_ReadlineCore ;

