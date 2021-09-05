"use strict";
/* ValueEditor.ts */
/// <reference path="types/KiwiLibrary.d.ts"/>
/// <reference path="types/Builtin.d.ts"/>
/// <reference path="types/Readline.d.ts"/>
class ValueEditor {
    edit(val) {
        let result = null;
        switch (valueType(val)) {
            case ValueType.boolType:
                result = this.editBool(toBoolean(val));
                break;
            case ValueType.numberType:
                result = this.editNumber(toNumber(val));
                break;
            case ValueType.stringType:
                result = this.editString(toString(val));
                break;
            case ValueType.dictionaryType:
                result = this.editDictionary(toDictionary(val));
                break;
            case ValueType.arrayType:
                result = this.editArray(toArray(val));
                break;
            case ValueType.dateType:
            case ValueType.rangeType:
            case ValueType.pointType:
            case ValueType.sizeType:
            case ValueType.rectType:
            case ValueType.enumType:
            case ValueType.URLType:
            case ValueType.colorType:
            case ValueType.imageType:
            case ValueType.nullType:
            case ValueType.objectType:
                console.print("[Error] This object is not editable.\n");
                result = null;
                break;
        }
        return result;
    }
    editBool(val) {
        console.print("current value: \"" + val ? "True" : "False" + "\"\n");
        let newval = this.inputBool("new value    ");
        if (newval != null) {
            if (this.check("Do replace current value ? [y/n] : ")) {
                return newval;
            }
        }
        return null;
    }
    editNumber(val) {
        console.print("current value: \"" + val + "\n");
        let newval = this.inputNumber("new value    ");
        if (newval != null) {
            if (this.check("Do replace current value ? [y/n] : ")) {
                return newval;
            }
        }
        return null;
    }
    editDictionary(val) {
        let newval = val;
        let dirty = false;
        while (true) {
            /* Make menu items */
            let items = [];
            let keys = Object.keys(newval);
            for (let i = 0; i < keys.length; i++) {
                let key = keys[i];
                let item = { key: `${i}`, label: key + " : " + newval[key] };
                items.push(item);
            }
            /* Add "add" menu */
            let anum = items.length;
            let aitem = { key: `a`, label: "Add new element" };
            items.push(aitem);
            /* Add "delete" menu */
            let dnum = items.length;
            let ditem = { key: `d`, label: "Delete element" };
            items.push(ditem);
            /* Add "quit" menu */
            let qnum = items.length;
            let qitem = { key: `q`, label: "Quit" };
            items.push(qitem);
            /* Output menu */
            let num = Readline.menu(items);
            if (num == anum) {
                /* Input key name */
                let newkey = this.inputString("new key: ");
                if (newkey != null) {
                    newval[newkey] = "";
                    dirty = true;
                }
            }
            else if (num == dnum) {
                /* Delete key:value */
                let kidx = this.inputNumber("Select key number to delete");
                if (kidx != null) {
                    let key = keys[kidx];
                    delete newval[key];
                    dirty = true;
                }
            }
            else if (num == qnum) {
                return dirty ? newval : null;
            }
            else {
                /* Edit dictionary element */
                let key = keys[num];
                let orgelm = newval[key];
                let newelm = this.editString(orgelm);
                if (newelm != null) {
                    /* Update element */
                    newval[key] = newelm;
                    dirty = true;
                }
            }
        }
        return null;
    }
    editArray(val) {
        let newval = val;
        let dirty = false;
        while (true) {
            /* Make menu items */
            let items = [];
            for (let i = 0; i < newval.length; i++) {
                let item = { key: `${i}`, label: newval[i] };
                items.push(item);
            }
            /* Add "add" menu */
            let anum = items.length;
            let aitem = { key: `a`, label: "Append new element" };
            items.push(aitem);
            /* Add "delete" menu */
            let dnum = items.length;
            let ditem = { key: `d`, label: "Delete element" };
            items.push(ditem);
            /* Add "quit" menu */
            let qnum = items.length;
            let qitem = { key: `q`, label: "Quit" };
            items.push(qitem);
            /* Output menu */
            let num = Readline.menu(items);
            if (num == anum) {
                /* Append new item */
                newval.push("");
                dirty = true;
            }
            else if (num == dnum) {
                /* Delete key:value */
                let kidx = this.inputNumber("Select index to delete");
                if (kidx != null) {
                    if (0 <= kidx && kidx < newval.length) {
                        let newarr = [];
                        for (let i = 0; i < newval.length; i++) {
                            if (i != kidx) {
                                newarr.push(newval[i]);
                            }
                        }
                        newval = newarr;
                        dirty = true;
                    }
                }
            }
            else if (num == qnum) {
                return dirty ? newval : null;
            }
            else if (0 <= num && num < newval.length) {
                /* Edit array element */
                let orgelm = newval[num];
                let newelm = this.editString(orgelm);
                if (newelm != null) {
                    /* Update element */
                    newval[num] = newelm;
                    dirty = true;
                }
            }
        }
        return dirty ? newval : val;
    }
    editString(val) {
        console.print("current value: \"" + val + "\"\n");
        console.print("new value    : ");
        let newval = Readline.inputLine();
        if (this.check("Do replace current value ? [y/n] : ")) {
            return newval;
        }
        else {
            return null;
        }
    }
    inputBool(msg) {
        console.print(msg + " [t or f] : ");
        let line = Readline.inputLine();
        let result;
        if (isEqualTrimmedStrings(line, "t")) {
            result = true;
        }
        else if (isEqualTrimmedStrings(line, "f")) {
            result = false;
        }
        else {
            result = null;
        }
        return result;
    }
    inputNumber(msg) {
        console.print(msg + " : ");
        let newval = Readline.inputLine();
        let fltval = parseFloat(newval);
        if (!isNaN(fltval)) {
            if (this.check("Do use this number ? [y/n] : ")) {
                return fltval;
            }
        }
        return null;
    }
    inputString(msg) {
        console.print(msg + " : ");
        let newval = Readline.inputLine();
        if (this.check("Do use this key ? [y/n] : ")) {
            return newval;
        }
        else {
            return null;
        }
    }
    check(message) {
        console.print(message);
        let ans = Readline.inputLine();
        if (ans == "y" || ans == "Y" || ans == "yes" || ans == "YES") {
            return true;
        }
        else {
            return false;
        }
    }
}
