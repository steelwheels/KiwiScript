/*
 * @file	UTType.swift
 * @brief	Test Value type operation
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiLibrary
import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public func UTType(context ctxt: KEContext, console cons: CNConsole) -> Bool
{
	var result: Bool 	 			= true
	var arr0: Array<JSValue> 			= []
	var dict0: Dictionary<AnyHashable, Any> 	= [:]

	let ctxt2 = KEContext(virtualMachine: JSVirtualMachine())

	cons.print(string: "* Test: JSValue(bool):\n")
	if let val = JSValue(bool: true, in: ctxt) {
		result = result && typeTest(value: val, context2: ctxt2, console: cons)
		arr0.append(val)
		dict0["bool"] = val
	} else {
		result = false
	}

	cons.print(string: "* Test: JSValue(Int32):\n")
	if let val = JSValue(int32: 1, in: ctxt) {
		result = result && typeTest(value: val, context2: ctxt2, console: cons)
		arr0.append(val)
		dict0["int32"] = val
	} else {
		result = false
	}

	cons.print(string: "* Test: JSValue(Double):\n")
	if let val = JSValue(double: 1.23, in: ctxt) {
		result = result && typeTest(value: val, context2: ctxt2, console: cons)
		arr0.append(val)
		dict0["double"] = val
	} else {
		result = false
	}

	cons.print(string: "* Test: JSValue(String):\n")
	if let val = JSValue(object: "Hello, world", in: ctxt) {
		result = result && typeTest(value: val, context2: ctxt2, console: cons)
		arr0.append(val)
		dict0["string"] = val
	} else {
		result = false
	}

	cons.print(string: "* Test: JSValue(Date):\n")
	if let val = JSValue(object: Date.init(timeIntervalSince1970: 0), in: ctxt) {
		result = result && typeTest(value: val, context2: ctxt2, console: cons)
		arr0.append(val)
		dict0["date"] = val
	} else {
		result = false
	}

	cons.print(string: "* Test: JSValue(URL):\n")
	let url = URL(string: "https://github.com/steelwheels")
	if let val = JSValue(object: KLURL(URL: url, context: ctxt), in: ctxt){
		result = result && typeTest(value: val, context2: ctxt2, console: cons)
		arr0.append(val)
		dict0["url"] = val
	} else {
		result = false
	}

	cons.print(string: "* Test: JSValue(Image):\n")
	let coreimg = CNImage(byReferencing: URL(string: "https://github.com/steelwheels/Amber/blob/master/Document/Images/AmberPlayerLogo.png")!)
	let imgobj  = KLImage(context: ctxt)
	imgobj.coreImage = coreimg
	if let val = JSValue(object: imgobj, in: ctxt){
		result = result && typeTest(value: val, context2: ctxt2, console: cons)
		arr0.append(val)
		dict0["image"] = val
	} else {
		result = false
	}

	cons.print(string: "* Test: JSValue(Array):\n")
	if let val = JSValue(object: arr0, in: ctxt) {
		result = result && typeTest(value: val, context2: ctxt2, console: cons)
	} else {
		result = false
	}

	cons.print(string: "* Test: JSValue(Dictionary):\n")
	if let val = JSValue(object: dict0, in: ctxt) {
		result = result && typeTest(value: val, context2: ctxt2, console: cons)
	} else {
		result = false
	}

	cons.print(string: "* Test: JSValue(Range):\n")
	let range0 = NSRange(location: 10, length: 3)
	let val0 = range0.toJSValue(context: ctxt)
	result = result && typeTest(value: val0, context2: ctxt2, console: cons)

	cons.print(string: "* Test: JSValue(Point):\n")
	let point0 = CGPoint(x: 1.0, y: 2.0)
	let val1 = point0.toJSValue(context: ctxt)
	result = result && typeTest(value: val1, context2: ctxt2, console: cons)

	cons.print(string: "* Test: JSValue(Size):\n")
	let size0 = CGSize(width: 3.0, height: 4.0)
	let val2 = size0.toJSValue(context: ctxt)
	result = result && typeTest(value: val2, context2: ctxt2, console: cons)

	cons.print(string: "* Test: JSValue(Rect):\n")
	let rect0 = CGRect(origin: CGPoint(x: 1.0, y: 2.0), size: CGSize(width: 3.0, height: 4.0))
	let val3  = rect0.toJSValue(context: ctxt)
	result = result && typeTest(value: val3, context2: ctxt2, console: cons)

	return result
}

private func typeTest(value val: JSValue, context2 ctxt2: KEContext, console cons: CNConsole) -> Bool
{
	let typename: String
	if let type = val.type {
		typename = type.toTypeDeclaration()
	} else {
		typename = "<none>"
	}
	cons.print(string: "type = " + typename + "\n")
	let conv = KLScriptValueToNativeValue()
	let nval = conv.convert(scriptValue: val)

	cons.print(string: "native: ")
	let ntxt = nval.toScript().toStrings().joined(separator: "\n")
	cons.print(string: ntxt + "\n")

	cons.print(string: "native -> js: ")
	let sconv = KLNativeValueToScriptValue(context: ctxt2)
	let jval  = sconv.convert(value: nval)
	let jtxt = jval.toScript().toStrings().joined(separator: "\n")
	cons.print(string: jtxt + "\n")

	/*
	cons.print(string: "duplicate: ")
	let duplicator = KLValueDuplicator(targetContext: ctxt2)
	let dval = duplicator.duplicate(value: val)
	let dtxt = dval.toText().toStrings().joined(separator: "\n")
	cons.print(string: dtxt + "\n")*/

	return true
}

