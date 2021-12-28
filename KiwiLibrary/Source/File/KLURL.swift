/**
 * @file	KLURL.swift
 * @brief	Define KLURL class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLURLProtocol: JSExport
{
	var isNull: JSValue { get }
	var absoluteString: JSValue { get }
	var path: JSValue { get }

	func appendingPathComponent(_ compval: JSValue) -> JSValue
	func loadText() -> JSValue
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

	public var isNull: JSValue {
		get {
			let result: Bool
			if let url = mURL {
				result = url.isNull
			} else {
				result = true
			}
			return JSValue(bool: result, in: mContext)
		}
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

	public func appendingPathComponent(_ compval: JSValue) -> JSValue {
		guard let cururl = mURL else {
			return JSValue(nullIn: mContext)
		}

		let compstr: String?
		if compval.isString {
			compstr = compval.toString()
		} else if compval.isURL {
			if let url = compval.toURL() {
				compstr = url.path
			} else {
				compstr = nil
			}
		} else {
			compstr = nil
		}
		if let component = compstr {
			let newurl = cururl.appendingPathComponent(component)
			let newobj = KLURL(URL: newurl, context: mContext)
			return JSValue(object: newobj, in: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	public func loadText() -> JSValue {
		if let url = mURL {
			if let text = url.loadContents() {
				return JSValue(object: text, in: mContext)
			} else {
				CNLog(logLevel: .error, message: "Failed to load text at \(url.absoluteString)", atFunction: #function, inFile: #file)
			}
		}
		return JSValue(nullIn: mContext)
	}
}

