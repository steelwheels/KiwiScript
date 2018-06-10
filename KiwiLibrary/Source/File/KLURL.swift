/**
 * @file	KLURL.swift
 * @brief	Define KLURL class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import JavaScriptCore
import Foundation

public protocol KLURLProtocol
{
	var absoluteString:	JSValue { get }
}

@objc public class KLURL: NSObject, KLURLProtocol
{
	private var mURL:	URL
	private var mContext:	KEContext

	public var URL: URL { get { return mURL }}

	public init(URL u: URL, context ctxt: KEContext){
		mURL	 = u
		mContext = ctxt
	}

	public var absoluteString: JSValue {
		get {
			let absstr = mURL.absoluteString
			return JSValue(object: absstr, in: mContext)
		}
	}
}

