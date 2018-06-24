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

