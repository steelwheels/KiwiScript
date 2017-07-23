/**
 * @file	KEPropertyTable.swift
 * @brief	Define KEPropertyTable
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Canary
import JavaScriptCore
import Foundation

private typealias FunctionRef	= (Any) -> Void

@objc protocol KEPropertyExport: JSExport
{
	func set(_ name: String, _ value: JSValue)
	func get(_ name: String) -> JSValue
}

@objc public class KEPropertyTable: NSObject, KEPropertyExport
{
	private var mContext:	KEContext
	private var mTable:	NSMutableDictionary // Key:String, value:JSValue
	private var mListeners:	Dictionary<String, KEListener>

	public init(context ctxt: KEContext){
		mContext   = ctxt
		mTable     = NSMutableDictionary(capacity: 8)
		mListeners = [:]
	}

	deinit {
		for prop in mListeners.keys {
			if let obs = mListeners[prop] {
				mTable.removeObserver(obs, forKeyPath: prop)
			}
		}
	}

	public func addListener(property prop: String, listener lsfunc: @escaping (Any) -> Void){
		var listener: KEListener
		if let lsfunc = mListeners[prop] {
			listener = lsfunc
		} else {
			listener = KEListener()
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
		return mTable.value(forKey: name) as? JSValue
	}

	public var propertyNames: Array<String> {
		get {
			if let keys = mTable.allKeys as? Array<String> {
				return keys
			}
			fatalError("Invalid key types")
		}
	}
}

private class KEListener: NSObject
{
	private var mListenerFuncs: Array<FunctionRef>

	public override init(){
		mListenerFuncs = []
	}

	public func add(listener lsfunc: @escaping (Any) -> Void)
	{
		mListenerFuncs.append(lsfunc)
	}

	public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
	{
		if let path = keyPath, let obj = object as? NSObject {
			if let val = obj.value(forKey: path) {
				for cbfunc in mListenerFuncs {
					cbfunc(val)
				}
				return
			}
		}
		NSLog("Could not get property")
	}
}
