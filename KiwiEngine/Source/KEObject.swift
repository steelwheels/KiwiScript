/**
 * @file	KEObject.swift
 * @brief	Define KEObject class
 * @par Copyright
 *   Copyright (C) 2017,2018 Steel Wheels Project
 */

import JavaScriptCore
import Foundation

private typealias FunctionRef	= (_ value: JSValue) -> Void

@objc protocol KEObjectProtocol: JSExport
{
	func set(_ name: String, _ value: JSValue)
	func get(_ name: String) -> JSValue
}

private class KEListener: NSObject
{
	private var mContext:		KEContext
	private var mListenerFuncs:	Array<FunctionRef>

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
			if let val = obj.value(forKey: path) as? JSValue{
				for cbfunc in mListenerFuncs {
					cbfunc(val)
				}
				return
			}
		}
		let except = KEException(context: mContext, message: "Could not get property: \(String(describing: keyPath))")
		mContext.exceptionCallback(except)
	}
}

@objc open class KEObject: NSObject, KEObjectProtocol
{
	private var mContext:		KEContext
	private var mTable:		NSMutableDictionary // Key:String, value:JSValue
	private var mListeners:		Dictionary<String, KEListener>

	public weak var owner:		AnyObject? = nil

	public init(context ctxt: KEContext){
		mContext   	= ctxt
		mTable     	= NSMutableDictionary(capacity: 8)
		mListeners 	= [:]
	}

	deinit {
		for prop in mListeners.keys {
			if let obs = mListeners[prop] {
				mTable.removeObserver(obs, forKeyPath: prop)
			}
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
}

