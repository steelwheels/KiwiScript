"use strict";
/* Contacts.ts */
/// <reference path="types/Builtin.d.ts"/>
/// <reference path="types/Process.d.ts"/>
function setupContacts() {
    let sem = new Semaphore(0);
    let loaded = false;
    Contacts.load(function (granted) {
        loaded = granted;
        sem.signal();
    });
    sem.wait();
    return loaded;
}
