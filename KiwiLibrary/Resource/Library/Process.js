"use strict";
/*
 * Process.ts
 */
/// <reference path="types/Builtin.d.ts"/>
/// <reference path="types/Enum.d.ts"/>
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
        this.mValue = {};
        this.mValue["count"] = initval;
    }
    signal() {
        let val = this.mValue["count"];
        if (val != null) {
            this.mValue["count"] = val - 1;
        }
        else {
            console.log("No count in Semaphore");
        }
    }
    wait() {
        while (true) {
            let count = this.mValue["count"];
            if (count != null) {
                if (count >= 0) {
                    sleep(0.1);
                }
                else {
                    break;
                }
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
function openURL(url) {
    let result = false;
    let sem = new Semaphore(0);
    let cbfunc = function (res) {
        result = res;
        sem.signal(); // Tell finish operation
    };
    _openURL(url, cbfunc);
    sem.wait(); // Wait finish operation
    return result;
}
function allocateThread(path, input, output, error) {
    if (path == null) {
        let newpath = openPanel("Select script file to execute", FileType.file, ["js", "jsh", "jspkg"]);
        if (newpath != null) {
            path = newpath;
        }
        else {
            return null;
        }
    }
    return _allocateThread(path, input, output, error);
}
function run(path, args, input, output, error) {
    let thread = allocateThread(path, input, output, error);
    if (thread != null) {
        thread.start(args);
        /* wait until finish process*/
        while (!thread.didFinished) {
            sleep(0.1);
        }
        return thread.exitCode;
    }
    else {
        return -1;
    }
}
