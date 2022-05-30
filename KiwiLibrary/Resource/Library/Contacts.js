"use strict";
/* Contacts.ts */
/// <reference path="types/Builtin.d.ts"/>
/// <reference path="types/Process.d.ts"/>
/// <reference path="types/Enum.d.ts"/>
function requestContactAccess() {
    let sem = new Semaphore(0);
    let authorized = false;
    Contacts.authorize(function (granted) {
        authorized = granted;
        sem.signal();
    });
    sem.wait();
    return authorized;
}
