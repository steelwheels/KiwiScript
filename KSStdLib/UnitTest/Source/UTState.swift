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

@objc class UTState: NSObject, UTStateProtocol
{

	/// Dictionary: Key: String, Value: CNValueObject
	private var mDictionary : NSMutableDictionary

	public static let Width:  NSString	= "width"
	public static let Height: NSString	= "height"

	public init(context ctxt: JSContext){
		mDictionary = NSMutableDictionary(capacity: 8)
		mDictionary.setObject(CNValueObject(value: .DoubleValue(value: 12.3)), forKey: UTState.Width)
		mDictionary.setObject(CNValueObject(value: .DoubleValue(value: 23.4)), forKey: UTState.Height)
	}

	public func setObserver(observer obs: NSObject){
		let keys: Array<String> = [String(UTState.Width), String(UTState.Height)]
		for key in keys {
			mDictionary.addObserver(obs, forKeyPath: key, options: .new, context: nil)
		}
	}

	var width: Double {
		get { return getValueObject(forKey: UTState.Width).value.doubleValue }
		set(val) { setValueObject(value: CNValueObject(value: .DoubleValue(value: val)), forKey: UTState.Width) }
	}

	var height: Double {
		get { return getValueObject(forKey: UTState.Height).value.doubleValue }
		set(val) { setValueObject(value: CNValueObject(value: .DoubleValue(value: val)), forKey: UTState.Height) }
	}

	private func getValueObject(forKey key: NSString) -> CNValueObject {
		if let o = mDictionary.object(forKey: key) {
			if let v = o as? CNValueObject {
				return v
			}
		}
		fatalError("No objrct")
	}

	private func setValueObject(value val: CNValueObject, forKey key: NSString) {
		mDictionary.setObject(val, forKey: key)
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
		let state0    = UTState(context: context)
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
		
		/*
		state0.setIntegerValue(name: "var0", value: 123)
		state0.setIntegerValue(name: "var0", value: 234)







		let inval = state0.integerValue(name: "var0")
		print("inValue = \(inval)")

		var result = false
		if let state1 = context.objectForKeyedSubscript(NSString(string: "state0")) {
			if let dict1 = state1.toDictionary() {
				if let num = dict1["var0"] as? NSNumber {
					let outval = num.intValue
					print("outValue = \(outval)")
					result = (inval+1 == outval)
				}
			}
		}

		return result
*/
	} else {
		print("[Error] Can not allocate JSContext")
		return false
	}
}
