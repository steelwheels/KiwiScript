/**
 * @file	KLURL.swift
 * @brief	Define KLURL class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLURLProtocol: JSExport
{
	var absoluteString: JSValue { get }
}

@objc public class KLURL: NSObject, KLURLProtocol
{
	private var mURL:	URL
	private var mContext:	KEContext

	public class func constructor(filePath path: String, context ctxt: KEContext) -> KLURL? {
		let url = URL(fileURLWithPath: path)
		return KLURL(URL: url, context: ctxt)
	}
	
	public init(URL u: URL, context ctxt: KEContext){
		mURL	 = u
		mContext = ctxt
	}

	public var absoluteString: JSValue {
		get {
			let str = mURL.absoluteString
			return JSValue(object: str, in: mContext)
		}
	}
}

/*
@objc public protocol KLURLProtocol: JSExport
{
	func fileURL(_ pathstring: JSValue) -> JSValue 	// -> KLURLObject
}

@objc public class KLURL: NSObject, KLURLProtocol
{


	public func fileURL(_ pathval: JSValue) -> JSValue {
		if pathval.isString {
			if let pathstr = pathval.toString() {
				let url = URL(fileURLWithPath: pathstr)
				let obj = KLURLObject(URL: url, context: mContext)
				return JSValue(object: obj, in: mContext)
			}
		}
		return JSValue(nullIn: mContext)
	}
}

@objc public protocol KLURLObjectProtocol: JSExport
{
	func absoluteString() -> JSValue
}

@objc public class KLURLObject: NSObject, KLURLObjectProtocol
{
	private var mURL:	URL
	private var mContext: 	KEContext

	public init(URL u: URL, context ctxt: KEContext){
		mURL     = u
		mContext = ctxt
	}

	public func absoluteString() -> JSValue {
		let absstr = mURL.absoluteString
		return JSValue(object: absstr, in: mContext)
	}
}

public protocol KLURLProtocol: JSExport
{
	var absoluteString:	JSValue { get }
}

@objc public class KLURL: NSObject, KLURLProtocol
{
	private var mURL:	URL
	private var mContext:	KEContext

	/* Constructor in JavaScript: URL(filePathString) */
	public class func constructor(value val: JSValue, context ctxt: KEContext) -> JSValue {

	}

	public init(URL u: URL, context ctxt: KEContext){
		mURL	 = u
		mContext = ctxt
	}

	public var absoluteString: JSValue {
		get {

		}
	}
}
*/

