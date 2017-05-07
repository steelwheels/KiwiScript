/**
 * @file	UTState.swift
 * @brief	Unit test for KSState class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation
import JavaScriptCore
import KSStdLib
import Canary

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
