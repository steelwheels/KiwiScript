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
                return ContactDatabase.recordCount ;
        }

	load(): boolean {
		let sem    = new Semaphore(0) ;
		let loaded = false ;
		ContactDatabase.load(function(granted): void {
			loaded = granted ;
			sem.signal() ;
		}) ;
		sem.wait() ;
		this.mIsLoaded = loaded ;
		return loaded ;
	}

	forEach(callback: (record: _ContactRecord) => void): void {
		ContactDatabase.forEach(callback) ;
	}
}

function ContactTable(): __ContactTable | null
{
	let table = _ContactTable ;

	let sem     = new Semaphore(0) ;
	let granted = false
	table.load(function(result){
		granted = result ;
		sem.signal() ;
	})
	sem.wait() ;
	return granted ? table : null ;
}
