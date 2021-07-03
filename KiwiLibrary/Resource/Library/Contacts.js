"use strict";
/* Contacts.ts */
/// <reference path="types/Builtin.d.ts"/>
/// <reference path="types/Process.d.ts"/>
class Contacts {
    constructor() {
        this.mIsLoaded = false;
    }
    get recordCount() {
        return ContactDatabase.recordCount;
    }
    load() {
        let sem = new Semaphore(0);
        let loaded = false;
        ContactDatabase.load(function (granted) {
            loaded = granted;
            sem.signal();
        });
        sem.wait();
        this.mIsLoaded = loaded;
        return loaded;
    }
    forEach(callback) {
        ContactDatabase.forEach(callback);
    }
}
