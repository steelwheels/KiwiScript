/**
 * @file	KEPropertyTable.swift
 * @brief	Define KEPropertyTable
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Canary
import JavaScriptCore
import Foundation

private typealias FunctionRef	= (_ value: JSValue) -> Void

@objc protocol KEPropertyExport: JSExport
{
	func set(_ name: String, _ value: JSValue)
	func get(_ name: String) -> JSValue
}

@objc public class KEPropertyTable: NSObject, KEPropertyExport
{
	private var mContext:		KEContext
	private var mTable:		NSMutableDictionary // Key:String, value:KEPropertyValue
	private var mListeners:		Dictionary<String, KEListener>
	private weak var mOwner:	AnyObject?

	public init(context ctxt: KEContext){
		//Swift.print("KEPropertyTable:init")
		mContext   	= ctxt
		mTable     	= NSMutableDictionary(capacity: 8)
		mListeners 	= [:]
		mOwner		= nil
	}

	deinit {
		for prop in mListeners.keys {
			if let obs = mListeners[prop] {
				mTable.removeObserver(obs, forKeyPath: prop)
			}
		}
	}

	public weak var owner: AnyObject? {
		set(newown){
			//Swift.print("KEPropertyTable:set \(String(describing: newown))")
			mOwner = newown
		}
		get {
			//Swift.print("KEPropertyTable:get \(String(describing: mOwner))")
			return mOwner
		}
	}

	public func addListener(property prop: String, listener lsfunc: @escaping (_ value: JSValue) -> Void){
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
		let obj = KEPropertyValue(value: value)
		mTable.setValue(obj, forKey: name)
	}

	public func get(_ name: String) -> JSValue {
		if let obj = mTable.value(forKey: name) as? KEPropertyValue {
			return obj.toValue(context: mContext)
		} else {
			return JSValue(undefinedIn: mContext)
		}
	}

	public func check(_ name: String) -> JSValue? {
		if let obj = mTable.value(forKey: name) as? KEPropertyValue {
			return obj.toValue(context: mContext)
		} else {
			return nil
		}
	}

	public func setObject(_ name: String, _ obj: JSExport) {
		if let value = JSValue(object: obj, in: mContext) {
			set(name, value)
		} else {
			NSLog("Failed tp allocate value")
		}
	}

	public func getObject(_ name: String) -> JSExport? {
		if let value = check(name) {
			if value.isObject {
				if let obj = value.toObject() as? JSExport {
					return obj
				}
			}
		}
		return nil
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
}

private class KEListener: NSObject
{
	private var mContext:	KEContext
	private var mListenerFuncs: Array<FunctionRef>

	public init(context ctxt: KEContext){
		mContext       = ctxt
		mListenerFuncs = []
	}

	public func add(listener lsfunc: @escaping (_ value: JSValue) -> Void)
	{
		mListenerFuncs.append(lsfunc)
	}

	public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
	{
		if let path = keyPath, let obj = object as? NSObject {
			if let pval = obj.value(forKey: path) as? KEPropertyValue {
				let val = pval.toValue(context: mContext)
				for cbfunc in mListenerFuncs {
					cbfunc(val)
				}
				return
			}
		}
		NSLog("Could not get property")
	}
}
