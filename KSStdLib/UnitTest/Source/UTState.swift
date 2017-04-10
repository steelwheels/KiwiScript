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

	public init(){
		let initvals: Array<KSStateInitialValue> = [
			KSStateInitialValue(key: UTState.Width,  value: .DoubleValue(value: 12.3)),
			KSStateInitialValue(key: UTState.Height, value: .DoubleValue(value: 23.4))
		]
		super.init(initialValues: initvals)
	}

	public var width: Double {
		get {
			print("*** get width ***")
			let val = member(forKey: UTState.Width)
			return val.doubleValue
		}
		set(v){
			print("*** set width ***")
			let val = CNValue.DoubleValue(value: v)
			setMember(value: val, forKey: UTState.Width)
		}
	}

	public var height: Double {
		get {
			let val = member(forKey: UTState.Height)
			return val.doubleValue
		}
		set(v){
			let val = CNValue.DoubleValue(value: v)
			setMember(value: val, forKey: UTState.Height)
		}
	}
}

private class UTObject: NSObject
{
	public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if let key = keyPath {
			var val: String = "?"
			if let dict = change {
				if let newval = dict[NSKeyValueChangeKey.newKey] as? CNValueObject {
					val = newval.value.description
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
