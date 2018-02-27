/**
 * @file	KLFile.swift
 * @brief	Define KLFile class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Canary
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLFileProtocol: JSExport
{
	func open(_ pathstr: JSValue, _ acctype: JSValue) -> JSValue
}

@objc public protocol KLFileObjectProtocol: JSExport
{
	func close() -> JSValue
	func getc() -> JSValue
	func getl() -> JSValue
	func put(_ str: JSValue) -> JSValue
}

@objc public class KLFile: NSObject, KLFileProtocol
{
	private var mContext:	KEContext
	private var mFile:	CNFile? = nil

	public init(context ctxt: KEContext){
		mContext = ctxt
	}

	public func open(_ pathval: JSValue, _ accval: JSValue) -> JSValue
	{
		if let pathstr = decodePathString(pathval), let acctype = decodeAccessType(accval) {
			let (file, _) = CNOpenFile(filePath: pathstr, accessType: acctype)
			if let f = file {
				let fileobj = KLFileObject(file: f, context: mContext)
				return JSValue(object: fileobj, in: mContext)
			}
		}
		return JSValue(nullIn: mContext)
	}

	public class func standardFile(fileType type: CNStandardFileType, context ctxt: KEContext) -> KLFileObject {
		let file    = CNStandardFile(type: type)
		return KLFileObject(file: file, context: ctxt)
	}

	private func decodePathString(_ pathval: JSValue) -> String? {
		if pathval.isString {
			return pathval.toString()
		}
		return nil
	}

	private func decodeAccessType(_ accval: JSValue) -> CNFileAccessType? {
		if accval.isString {
			if let accstr = accval.toString() {
				let result : CNFileAccessType?
				switch accstr {
				case "r":  result = .ReadAccess
				case "w":  result = .WriteAccess
				case "w+": result = .AppendAccess
				default:   result = nil
				}
				return result
			}
		}
		return nil
	}
}

@objc public class KLFileObject: NSObject, KLFileObjectProtocol
{
	private var mFile:	CNFile
	private var mContext:	KEContext

	public init(file fl: CNFile, context ctxt: KEContext){
		mFile    = fl
		mContext = ctxt
	}

	public func close() -> JSValue {
		let result: Int32
		if mFile.isClosed() {
			/* Already closed */
			result = 1
		} else {
			/* Not closed yet */
			mFile.close()
			result = 0
		}
		return JSValue(int32: result, in: mContext)
	}

	public func getc() -> JSValue {
		if let c = mFile.getChar() {
			let str = String(c)
			return JSValue(object: str, in: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	public func getl() -> JSValue {
		if let line = mFile.getLine() {
			return JSValue(object: line, in: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	public func put(_ strval: JSValue) -> JSValue {
		var result: Int32 = 0
		if strval.isString {
			if let str = strval.toString() {
				let count = mFile.put(string: str)
				result = Int32(count)
			}
		}
		return JSValue(int32: result, in: mContext)
	}
}

