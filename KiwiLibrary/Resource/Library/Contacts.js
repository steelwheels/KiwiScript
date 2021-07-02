"use strict";
/* Contacts.ts */
/// <reference path="types/Builtin.d.ts"/>
/// <reference path="types/Process.d.ts"/>
class Contacts {
    constructor() {
        this.mIsLoaded = false;
    }
    get recordCount() {
        return _Contacts.recordCount;
    }
    load() {
        let sem = new Semaphore(0);
        let loaded = false;
        _Contacts.load(function (granted) {
            loaded = granted;
            sem.signal();
        });
        sem.wait();
        this.mIsLoaded = loaded;
        return loaded;
    }
}
