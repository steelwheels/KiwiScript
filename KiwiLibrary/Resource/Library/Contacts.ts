/* Contacts.ts */

/// <reference path="types/Builtin.d.ts"/>
/// <reference path="types/Process.d.ts"/>

function requestContactAccess(): boolean
{
	let sem = new Semaphore(0) ;
	let authorized = false ;
	Contacts.authorize(function(granted): void {
		authorized = granted ;
		sem.signal() ;
	}) ;
	sem.wait() ;
	return authorized ;
}
