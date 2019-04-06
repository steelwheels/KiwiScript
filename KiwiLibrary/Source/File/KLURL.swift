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
	var isValid: JSValue { get }
	var absoluteString: JSValue { get }
	var path: JSValue { get }
}

@objc public class KLURL: NSObject, KLURLProtocol, KLEmbeddedObject
{
	private var mURL:	URL?
	private var mContext:	KEContext
	
	public init(URL u: URL?, context ctxt: KEContext){
		mURL	 	= u
		mContext 	= ctxt
	}

	public func copy(context ctxt: KEContext) -> KLEmbeddedObject {
		return KLURL(URL: self.mURL, context: ctxt)
	}

	public var url: URL? { get { return mURL }}

	public var isValid: JSValue {
		get { return JSValue(bool: mURL != nil, in: mContext) }
	}

	public var absoluteString: JSValue {
		get {
			if let url = mURL {
				return JSValue(object: url.absoluteString, in: mContext)
			} else {
				return JSValue(nullIn: mContext)
			}
		}
	}

	public var path: JSValue {
		get {
			if let url = mURL {
				return JSValue(object: url.path, in: mContext)
			} else {
				return JSValue(nullIn: mContext)
			}
		}
	}
}

