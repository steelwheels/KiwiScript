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
	public static let StdInName	= "_stdin"
	public static let StdOutName	= "_stdout"
	public static let StdErrName	= "_stderr"

	public static let EOFValue:Int32	= -1

	private var mFile:	CNFile
	private var mContext:	KEContext

	public init(file fl: CNFile, context ctxt: KEContext){
		mFile    = fl
		mContext = ctxt
	}

	public var endOfFile: JSValue {
		get { return JSValue(int32: KLFile.EOFValue, in: mContext )}
	}

	public var fileHandle: FileHandle {
		get { return mFile.fileHandle }
	}

	public func getc() -> JSValue {
		let result: JSValue
		switch mFile.getc() {
		case .char(let c):
			result = JSValue(object: String(c), in: mContext)
		case .endOfFile:
			result = self.endOfFile
		case .null:
			result = JSValue(nullIn: mContext)
		@unknown default:
			NSLog("Unknown case at \(#function)")
			result = self.endOfFile
		}
		return result
	}

	public func getl() -> JSValue {
		let result: JSValue
		switch mFile.getl() {
		case .line(let str):
			result = JSValue(object: str, in: mContext)
		case .endOfFile:
			result = self.endOfFile
		case .null:
			result = JSValue(nullIn: mContext)
		@unknown default:
			NSLog("Unknown case at \(#function)")
			result = self.endOfFile
		}
		return result
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

