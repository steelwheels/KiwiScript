/**
 * Builtin.d.ts
 */

interface ReadlineCoreIF {
	input():	string | null ;
	history():	string[] ;
}

declare var _readlineCore:	ReadlineCoreIF ;

