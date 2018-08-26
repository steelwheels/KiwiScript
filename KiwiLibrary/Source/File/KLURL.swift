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
		if let url = URL(string: path) {
			return KLURL(URL: url, context: ctxt)
		} else {
			return nil
		}
	}
	
	public init(URL u: URL, context ctxt: KEContext){
		mURL	 = u
		mContext = ctxt
	}

	public var url: URL { get { return mURL }}

	public var absoluteString: JSValue {
		get {
			let str = mURL.absoluteString
			return JSValue(object: str, in: mContext)
		}
	}
}

