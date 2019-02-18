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
	var path: JSValue { get }
}

@objc public class KLURL: NSObject, KLURLProtocol
{
	private var mURL:	URL?
	private var mContext:	KEContext
	
	public init(URL u: URL, context ctxt: KEContext){
		mURL	 	= u
		mContext 	= ctxt
	}

	public init(string str: String, context ctxt: KEContext){
		mURL		= URL(string: str)
		mContext	= ctxt
	}

	public init(value val: JSValue, ctxt: KEContext) {
		let url: URL?
		if val.isString {
			url = URL(string: val.toString())
		} else {
			url = nil
		}
		mURL		= url
		mContext	= ctxt
	}

	public var url: URL? { get { return mURL }}

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

