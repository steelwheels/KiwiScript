"use strict";
/*
 * Process.ts
 */
/// <reference path="types/Builtin.d.ts"/>
function _waitUntilExitOne(process) {
    while (!process.didFinished) {
        /* wait until exit */
    }
    return process.exitCode;
}
function _waitUntilExitAll(processes) {
    let ecode = 0;
    for (let process of processes) {
        let state = _waitUntilExitOne(process);
        if (state != 0) {
            ecode = state;
        }
    }
    return ecode;
}
class Semaphore {
    constructor(initval) {
        this.mValue = Dictionary();
        this.mValue.set("count", initval);
    }
    signal() {
        let val = this.mValue.get("count");
        this.mValue.set("count", val - 1);
    }
    wait() {
        while (true) {
            let count = this.mValue.get("count");
            if (count >= 0) {
                sleep(0.1);
            }
            else {
                break;
            }
        }
    }
}
class CancelException extends Error {
    constructor(code) {
        super("CancelException");
        this.code = code;
    }
}
function _cancel() {
    throw new CancelException(ExitCode.exception);
}
function openPanel(title, type, exts) {
    let result = null;
    let sem = new Semaphore(0);
    let cbfunc = function (url) {
        result = url;
        sem.signal(); // Tell finish operation
    };
    _openPanel(title, type, exts, cbfunc);
    sem.wait(); // Wait finish operation
    return result;
}
function savePanel(title) {
    let result = null;
    let sem = new Semaphore(0);
    let cbfunc = function (url) {
        result = url;
        sem.signal(); // Tell finish operation
    };
    _savePanel(title, cbfunc);
    sem.wait(); // Wait finish operation
    return result;
}
function run(path, input, output, error) {
    if (path == null) {
        let newpath = openPanel("Select script file to execute", FileType.file, ["js", "jsh", "jspkg"]);
        if (newpath != null) {
            path = newpath;
        }
        else {
            return null;
        }
    }
    return _run(path, input, output, error);
}
