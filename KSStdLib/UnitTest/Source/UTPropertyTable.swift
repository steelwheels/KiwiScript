/**
 * @file	UTState.swift
 * @brief	Unit test for KSState class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KSStdLib
import Canary

public func testPropertyTable() -> Bool
{
	let table = KSPropertyTable()

	let res00 = checkError(message: "bool", result: table.setBooleanProperty(identifier: "bool0", value: true))
	let res01: Bool
	if let bool0 = table.booleanProperty(identifier: "bool0") {
		if bool0 {
			Swift.print("getTest: bool ... OK")
			res01 = true
		} else {
			Swift.print("getTest: bool ... NG")
			res01 = true
		}
	} else {
		Swift.print("getTest: bool ... Error")
		res01 = false
	}

	let res10 = checkError(message: "int", result: table.setIntProperty(identifier: "int0", value: -1234))
	let res11 = checkValue(message: "int", value: table.intProperty(identifier: "int0"), expected: -1234)

	let res20 = checkError(message: "uint", result: table.setUIntProperty(identifier: "uint0", value: 2345))
	let res21 = checkValue(message: "uint", value: table.uIntProperty(identifier: "uint0"), expected: 2345)

	let res30 = checkError(message: "float", result: table.setFloatProperty(identifier: "float0", value: 1.234))
	let res31 = checkValue(message: "float", value: table.floatProperty(identifier: "float0"), expected: 1.234)

	let res40 = checkError(message: "double", result: table.setDoubleProperty(identifier: "double0", value: -1.234))
	let res41 = checkValue(message: "double", value: table.doubleProperty(identifier: "double0"), expected: -1.234)

	let res50 = checkError(message: "string", result: table.setStringProperty(identifier: "string0", value: "hello"))
	let res51: Bool
	if let string0 = table.stringProperty(identifier: "string0") {
		if string0.compare("hello") == ComparisonResult.orderedSame {
			Swift.print("getTest: string ... OK")
			res51 = true
		} else {
			Swift.print("getTest: string ... NG")
			res51 = true
		}
	} else {
		Swift.print("getTest: string ... Error")
		res51 = false
	}

	return res00 && res01 && res10 && res11 && res20 && res21
	 && res30 && res31 && res40 && res41 && res50 && res51
}

private func checkError(message msg:String, result err: KSPropertyError) -> Bool
{
	Swift.print("setTest: \(msg) :", terminator:"")
	switch err {
	case .NoError:
		Swift.print(" ... OK")
		return true
	default:
		Swift.print(" ... Error\(err.description)")
		return false
	}
}

private func checkValue<T:Comparable>(message msg:String, value val0: T?, expected val1: T) -> Bool
{
	Swift.print("getTest: \(msg) :", terminator:"")
	if let v = val0 {
		if v == val1 {
			Swift.print(" ... OK(\(v))")
			return true
		} else {
			Swift.print(" ... NG(\(v) != \(val1))")
			return false
		}
	} else {
		Swift.print(" ... Error")
		return false
	}
}

/*
@objc protocol UTStateProtocol: JSExport
{
	var width:  Double { get set }
	var height: Double { get set }
}

/* Must be public for accessed in JavaScriptCore */
@objc class UTState: KSState, UTStateProtocol
{
	public static let Width	 = NSString(string: "width")
	public static let Height = NSString(string: "height")

	public override init(){
		super.init()
		let initvals: Array<KSStateInitialValue> = [
			KSStateInitialValue(key: UTState.Width,  value: CNValue(doubleValue: 12.3)),
			KSStateInitialValue(key: UTState.Height, value: CNValue(doubleValue: 23.4))
		]
		setInitialValues(initialValues: initvals)
	}

	public var width: Double {
		get {
			if let val = member(forKey: UTState.Width) {
				print("[UTState] get width : \(val.doubleValue!)")
				return val.doubleValue!
			} else {
				print("[UTState] get width : nil (Error)")
				return 0.0
			}
		}
		set(v){
			let val = CNValue(doubleValue: v)
			print("[UTState] set width: \(val.doubleValue!)")
			let err = setMember(value: val, forKey: UTState.Width)
			if err != .NoError {
				print("[ERROR] \(err.description)")
			}
		}
	}

	public var height: Double {
		get {
			if let val = member(forKey: UTState.Height){
				return val.doubleValue!
			} else {
				print("[UTState] get height : nil (Error)")
				return 0.0
			}
		}
		set(v){
			let val = CNValue(doubleValue: v)
			let err = setMember(value: val, forKey: UTState.Height)
			if err != .NoError {
				print("[ERROR] \(err.description)")
			}
		}
	}
}

private class UTObject: NSObject
{
	public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if let key = keyPath {
			var val: String = "?"
			if let dict = change {
				if let newval = dict[NSKeyValueChangeKey.newKey] as? CNValue {
					val = newval.description
				}
			}
			print("observeValue: key=\(key), value=\(val)")
		} else {
			print("observeValue: key=nil")
		}
	}
}

public func testState() -> Bool
{
	if let context = JSContext() {
		print("[setup]")
		KSStdLib.setup(context: context)
		KSStdLib.setupRuntime(context: context, console: CNTextConsole())
		
		let observer0 = UTObject()
		let state0    = UTState()
		state0.setObserver(observer: observer0)

		Swift.print("state0.width = 100.0")
		state0.width = 100.0

		context.setObject(state0, forKeyedSubscript: NSString(string: "state"))
		context.exceptionHandler = { (context, exception) in
			var desc: String
			if let e = exception {
				desc = e.toString()
			} else {
				desc = "nil"
			}
			print("JavaScript Error: \(desc)")
		}

		print("[evalateScript]")
		context.evaluateScript("state.width += 1.0 ; console.put(\"inJs = \" + state.width) ; ")
		return true
	} else {
		print("[Error] Can not allocate JSContext")
		return false
	}
}
*/

