/**
 * @file	KEObject.swift
 * @brief	Define KEObject class
 * @par Copyright
 *   Copyright (C) 2017,2018 Steel Wheels Project
 */

import JavaScriptCore
import Foundation

@objc protocol KEObjectProtocol: JSExport
{
	func set(_ name: String, _ value: JSValue) -> Void
	func get(_ name: String) -> JSValue
}

private enum Function {
	case reference((_ value: JSValue) -> Void)
	case value(JSValue)
}

private class KEListener: NSObject
{
	private var mContext:		KEContext
	private var mListenerFuncs:	Array<Function>

	public init(context ctxt: KEContext){
		mContext       = ctxt
		mListenerFuncs = []
	}

	public func add(listener lsfunc: Function)
	{
		mListenerFuncs.append(lsfunc)
	}

	public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
	{
		if let path = keyPath, let obj = object as? NSObject {
			if let val = obj.value(forKey: path) as? JSValue{
				for cbfunc in mListenerFuncs {
					switch cbfunc {
					case .reference(let ref):
						let _ = ref(val)
					case .value(let ref):
						let _ = ref.call(withArguments: [val])
					}
				}
				return
			}
		}
		let except = KEException(context: mContext, message: "Could not get property: \(String(describing: keyPath))")
		mContext.exceptionCallback(except)
	}
}

open class KEObject: NSObject, KEObjectProtocol
{
	private var mContext:		KEContext
	private var mTable:		NSMutableDictionary // Key:String, value:JSValue
	private var mListeners:		Dictionary<String, KEListener>

	public weak var owner:		AnyObject? = nil

	public init(context ctxt: KEContext){
		mContext   	= ctxt
		mTable     	= NSMutableDictionary(capacity: 8)
		mListeners 	= [:]
		super.init()

		setup(context: ctxt)
	}

	deinit {
		for prop in mListeners.keys {
			if let obs = mListeners[prop] {
				mTable.removeObserver(obs, forKeyPath: prop)
			}
		}
	}

	private func setup(context ctxt: KEContext) {
		let listnerfunc: @convention(block) (_ property: JSValue, _ listenerfunc: JSValue) -> Void = {
			(_ property: JSValue, _ listenerfunc: JSValue) -> Void in
			if let propname = property.toString()  {
				self.addListener(property: propname, reference: Function.value(listenerfunc))
			} else {
				NSLog("[Error] Invalid parameters\n")
			}
		}
		 set("addListener", JSValue(object: listnerfunc, in: ctxt))
	}

	public func addListener(property prop: String, listener lsfunc: @escaping (_ value: JSValue) -> Void){
		addListener(property: prop, reference: .reference(lsfunc))
	}

	private func addListener(property prop: String, reference lsfunc: Function) {
		var listener: KEListener
		if let lsfunc = mListeners[prop] {
			listener = lsfunc
		} else {
			listener = KEListener(context: mContext)
			mTable.addObserver(listener, forKeyPath: prop, options: [.new], context: nil)
			mListeners[prop] = listener
		}
		listener.add(listener: lsfunc)
	}

	public func set(_ name: String, _ value: JSValue) {
		mTable.setValue(value, forKey: name)
	}

	public func get(_ name: String) -> JSValue {
		if let value = mTable.value(forKey: name) as? JSValue {
			return value
		} else {
			return JSValue(undefinedIn: mContext)
		}
	}

	public func check(_ name: String) -> JSValue? {
		if let value = mTable.value(forKey: name) as? JSValue {
			return value
		} else {
			return nil
		}
	}

	public var context: KEContext {
		get { return mContext }
	}

	public var propertyNames: Array<String> {
		get {
			if let keys = mTable.allKeys as? Array<String> {
				return keys
			}
			fatalError("Invalid key types")
		}
	}

	public func getBoolean(name nm: String) -> Bool {
		let val = get(nm)
		if val.isBoolean {
			return val.toBool()
		} else {
			fatalError("Invalid object at \(#function)")
		}
	}

	public func set(name nm: String, booleanValue value: Bool) {
		if let valobj = JSValue(bool: value, in: context) {
			set(nm, valobj)
		}
	}

	public func getInt32(name nm: String) -> Int32 {
		let val = get(nm)
		if val.isNumber {
			return val.toInt32()
		} else {
			fatalError("Invalid object at \(#function)")
		}
	}

	public func set(name nm: String, int32Value value: Int32) {
		if let valobj = JSValue(int32: value, in: context) {
			set(nm, valobj)
		}
	}

	public func getDouble(name nm: String) -> Double {
		let val = get(nm)
		if val.isNumber {
			return val.toDouble()
		} else {
			fatalError("Invalid object at \(#function)")
		}
	}

	public func set(name nm: String, doubleValue value: Double) {
		if let valobj = JSValue(double: value, in: context) {
			set(nm, valobj)
		}
	}
}

