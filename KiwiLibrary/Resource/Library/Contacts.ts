/* Contacts.ts */

/// <reference path="types/Builtin.d.ts"/>
/// <reference path="types/Process.d.ts"/>

class Contacts
{
	mIsLoaded:	boolean ;

	constructor(){
		this.mIsLoaded = false ;
	}

        get recordCount(): number {
                return _Contacts.recordCount ;
        }

	load(): boolean {
		let sem    = new Semaphore(0) ;
		let loaded = false ;
		_Contacts.load(function(granted): void {
			loaded = granted ;
			sem.signal() ;
		}) ;
		sem.wait() ;
		this.mIsLoaded = loaded ;
		return loaded ;
	}
}

