/**
 * @file	KLFile.swift
 * @brief	Define KLFile class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLFileProtocol: JSExport
{
	func getc() -> JSValue
	func getl() -> JSValue
	func put(_ str: JSValue) -> JSValue
	func close()
}

@objc public class KLFile: NSObject, KLFileProtocol
{
	private var mFile:	CNTextFile
	private var mContext:	KEContext

	public init(file fl: CNTextFile, context ctxt: KEContext){
		mFile    = fl
		mContext = ctxt
	}

	public var file: CNTextFile {
		get { return mFile }
	}

	public var fileHandle: FileHandle {
		get { return mFile.fileHandle }
	}

	public func getc() -> JSValue {
		if let c = mFile.getc() {
			let str = String(c)
			return JSValue(object: str, in: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	public func getl() -> JSValue {
		if let l = mFile.getl() {
			return JSValue(object: l, in: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	public func put(_ strval: JSValue) -> JSValue {
		var result: Int32 = 0
		if strval.isString {
			if let str = strval.toString() {
				mFile.put(string: str)
				result = Int32(str.lengthOfBytes(using: .utf8))
			}
		}
		return JSValue(int32: result, in: mContext)
	}

	public func close(){
		mFile.close()
	}
}

