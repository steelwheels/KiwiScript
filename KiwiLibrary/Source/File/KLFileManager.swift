/**
 * @file	KLFileManager.swift
 * @brief	Define KLFileManager class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLFileManagerProtocol: JSExport
{
	func open(_ pathstr: JSValue, _ acctype: JSValue) -> JSValue

	func checkFileType(_ pathstr: JSValue) -> JSValue
	func uti(_ pathstr: JSValue) -> JSValue
}

@objc public class KLFileManager: NSObject, KLFileManagerProtocol
{
	private var mContext:	KEContext
	private var mStdin:	KLFile
	private var mStdout:	KLFile
	private var mStderr:	KLFile

	public init(context ctxt: KEContext){
		mContext   = ctxt
		mStdin	   = KLFile(file: CNStandardFile(type: .input),  context: ctxt)
		mStdout	   = KLFile(file: CNStandardFile(type: .output), context: ctxt)
		mStderr    = KLFile(file: CNStandardFile(type: .error),  context: ctxt)
	}

	public func open(_ pathval: JSValue, _ accval: JSValue) -> JSValue
	{
		guard let acctype = decodeAccessType(accval) else {
			return JSValue(nullIn: mContext)
		}

		if let pathstr = decodePathString(pathval) {
			let (file, _) = CNOpenFile(filePath: pathstr, accessType: acctype)
			if let f = file {
				let fileobj = KLFile(file: f, context: mContext)
				return JSValue(object: fileobj, in: mContext)
			}
		} else if let pathurl = decodePathURL(pathval) {
			let (file, _) = CNOpenFile(URL: pathurl, accessType: acctype)
			if let f = file {
				let fileobj = KLFile(file: f, context: mContext)
				return JSValue(object: fileobj, in: mContext)
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func standardFile(fileType type: CNStandardFileType, context ctxt: KEContext) -> KLFile {
		let result: KLFile
		switch type {
		case .input:	result = mStdin
		case .output:	result = mStdout
		case .error:	result = mStderr
		}
		return result
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

	private func decodePathString(_ pathval: JSValue) -> String? {
		if pathval.isString {
			return pathval.toString()
		}
		return nil
	}

	private func decodePathURL(_ pathval: JSValue) -> URL? {
		if pathval.isURL {
			return pathval.toURL()
		}
		return nil
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
				var result: Int32
				switch fmanager.checkFileType(pathString: pathstr) {
				case .NotExist:		result = CNFileType.NotExist.rawValue
				case .File:		result = CNFileType.File.rawValue
				case .Directory:	result = CNFileType.Directory.rawValue
				}
				return JSValue(int32: result, in: self.mContext)
			}
		}
		return JSValue(int32: CNFileType.NotExist.rawValue, in: self.mContext)
	}
}
