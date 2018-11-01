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
	func open(_ pathstr: JSValue, _ acctype: JSValue) -> JSValue

	var type: JSValue { get }

	func checkFileType(_ pathstr: JSValue) -> JSValue
	func uti(_ pathstr: JSValue) -> JSValue
}

@objc public protocol KLFileObjectProtocol: JSExport
{
	func close() -> JSValue
	func getc() -> JSValue
	func getl() -> JSValue
	func put(_ str: JSValue) -> JSValue
}

@objc public protocol KLFileTypeProtocol: JSExport
{
	var NotExist:	JSValue { get }
	var File:	JSValue { get }
	var Directory:	JSValue { get }
}

@objc public class KLFile: NSObject, KLFileProtocol
{
	private var mContext:	KEContext
	private var mFileType:	KLFileTypeObject
	private var mFileValue:	JSValue
	private var mStdin:	KLFileObject
	private var mStdout:	KLFileObject
	private var mStderr:	KLFileObject

	public init(context ctxt: KEContext){
		mContext   = ctxt
		mFileType  = KLFileTypeObject(context: ctxt)
		mFileValue = JSValue(object: mFileType, in: ctxt)
		mStdin	   = KLFileObject(file: CNStandardFile(type: .input),  context: ctxt)
		mStdout	   = KLFileObject(file: CNStandardFile(type: .output), context: ctxt)
		mStderr    = KLFileObject(file: CNStandardFile(type: .error),  context: ctxt)
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

	public func standardFile(fileType type: CNStandardFileType, context ctxt: KEContext) -> KLFileObject {
		let result: KLFileObject
		switch type {
		case .input:	result = mStdin
		case .output:	result = mStdout
		case .error:	result = mStderr
		}
		return result
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

	public var type: JSValue {
		get { return mFileValue }
	}

	public func uti(_ pathval: JSValue) -> JSValue {
		if pathval.isString {
			if let pathstr = pathval.toString() {
				let pathurl = URL(fileURLWithPath: pathstr)
				if let uti = CNFilePath.UTIForFile(URL: pathurl) {
					return JSValue(object: uti, in: mContext)
				}
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func checkFileType(_ pathval: JSValue) -> JSValue {
		if pathval.isString {
			if let pathstr = pathval.toString() {
				let fmanager = FileManager.default
				var result: JSValue
				switch fmanager.checkFileType(pathString: pathstr) {
				case .NotExist:		result = mFileType.NotExist
				case .File:		result = mFileType.File
				case .Directory:	result = mFileType.Directory
				}
				return result
			}
		}
		return mFileType.NotExist
	}
}

@objc public class KLFileObject: NSObject, KLFileObjectProtocol
{
	private var mFile:	CNTextFile
	private var mContext:	KEContext

	public init(file fl: CNTextFile, context ctxt: KEContext){
		mFile    = fl
		mContext = ctxt
	}

	public var file: CNTextFile {
		return mFile
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
				mFile.put(string: str)
				result = Int32(str.lengthOfBytes(using: .utf8))
			}
		}
		return JSValue(int32: result, in: mContext)
	}
}

@objc public class KLFileTypeObject: NSObject, KLFileTypeProtocol
{
	private var	mContext:		KEContext
	private var	mNotExitValue:		JSValue
	private var 	mFileValue:		JSValue
	private var 	mDirectoryValue:	JSValue

	public init(context ctxt: KEContext){
		mContext 	= ctxt
		mNotExitValue	= JSValue(int32: CNFileType.NotExist.rawValue,	in: mContext)
		mFileValue	= JSValue(int32: CNFileType.File.rawValue,	in: mContext)
		mDirectoryValue	= JSValue(int32: CNFileType.Directory.rawValue,	in: mContext)
	}

	public var NotExist:	JSValue { get { return mNotExitValue	}}
	public var File:	JSValue { get { return mFileValue	}}
	public var Directory:	JSValue { get { return mDirectoryValue 	}}
}

