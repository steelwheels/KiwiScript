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

	func isReadable(_ pathstr: JSValue) -> JSValue
	func isWritable(_ pathstr: JSValue) -> JSValue
	func isExecutable(_ pathstr: JSValue) -> JSValue
	func isDeletable(_ pathstr: JSValue) -> JSValue
	func isAccessible(_ pathstr: JSValue, _ acctype: JSValue) -> JSValue

	func normalizePath(_ parent: JSValue, _ subdir: JSValue) -> JSValue

	func homeDirectory() -> JSValue
	func temporaryDirectory() -> JSValue

	func checkFileType(_ pathstr: JSValue) -> JSValue
	func uti(_ pathstr: JSValue) -> JSValue
}

@objc public class KLFileManager: NSObject, KLFileManagerProtocol
{
	private var mContext:		KEContext
	private var mEnvironment:	CNEnvironment
	private var mInputFileHandle:	FileHandle
	private var mOutputFileHandle:	FileHandle
	private var mErrorFileHandle:	FileHandle

	public init(context ctxt: KEContext, environment env: CNEnvironment, input inhdl: FileHandle, output outhdl: FileHandle, error errhdl: FileHandle){
		mContext		= ctxt
		mEnvironment		= env
		mInputFileHandle	= inhdl
		mOutputFileHandle	= outhdl
		mErrorFileHandle	= errhdl
	}

	public func open(_ pathval: JSValue, _ accval: JSValue) -> JSValue
	{
		guard let acctype = decodeAccessType(accval) else {
			return JSValue(nullIn: mContext)
		}

		let fmanager = FileManager.default
		if let pathstr = decodePathString(pathval) {
			let pathurl = fmanager.fullPathURL(relativePath: pathstr, baseDirectory: mEnvironment.currentDirectory.path)
			switch fmanager.openFile(URL: pathurl, accessType: acctype) {
			case .ok(let file):
				let fileobj = KLFile(file: file, context: mContext)
				return JSValue(object: fileobj, in: mContext)
			case .error(_):
				mErrorFileHandle.write(string: "Failed to write \(pathval)")
			}
		} else if let pathurl = decodePathURL(pathval) {
			switch fmanager.openFile(URL: pathurl, accessType: acctype) {
			case .ok(let file):
				let fileobj = KLFile(file: file, context: mContext)
				return JSValue(object: fileobj, in: mContext)
			case .error(_):
				mErrorFileHandle.write(string: "Failed to write \(pathval)")
			}
		}
		return JSValue(nullIn: mContext)
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

	public func isReadable(_ pathval: JSValue) -> JSValue {
		var result = false
		if let url = valueToURL(value: pathval) {
			result = FileManager.default.isReadableFile(atPath: url.path)
		}
		return JSValue(bool: result, in: mContext)
	}

	public func isWritable(_ pathval: JSValue) -> JSValue {
		var result = false
		if let url = valueToURL(value: pathval) {
			result = FileManager.default.isWritableFile(atPath: url.path)
		}
		return JSValue(bool: result, in: mContext)
	}

	public func isExecutable(_ pathval: JSValue) -> JSValue {
		var result = false
		if let url = valueToURL(value: pathval) {
			result = FileManager.default.isExecutableFile(atPath: url.path)
		}
		return JSValue(bool: result, in: mContext)
	}

	public func isDeletable(_ pathval: JSValue) -> JSValue {
		var result = false
		if let url = valueToURL(value: pathval) {
			result = FileManager.default.isDeletableFile(atPath: url.path)
		}
		return JSValue(bool: result, in: mContext)
	}

	public func isAccessible(_ pathval: JSValue, _ accval: JSValue) -> JSValue {
		if pathval.isString && accval.isNumber {
			let pathstr = pathval.toString()
			let accnum  = accval.toInt32()
			let acctype: CNFileAccessType?
			switch accnum {
			case CNFileAccessType.ReadAccess.rawValue:
				acctype = .ReadAccess
			case CNFileAccessType.WriteAccess.rawValue:
				acctype = .WriteAccess
			case CNFileAccessType.AppendAccess.rawValue:
				acctype = .AppendAccess
			default:
				acctype = nil
			}
			if let path = pathstr, let type = acctype {
				let result = FileManager.default.isAccessible(pathString: path, accessType: type)
				return JSValue(bool: result, in: mContext)
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func normalizePath(_ parent: JSValue, _ subdir: JSValue) -> JSValue {
		if let parenturl = valueToURL(value: parent),
		   let subdirstr = valueToString(value: subdir) {
			var url = parenturl.appendingPathComponent(subdirstr)
			url.standardize()
			return JSValue(object: KLURL(URL: url, context: mContext), in: mContext)
		}
		return JSValue(nullIn: mContext)
	}

	public func homeDirectory() -> JSValue {
		let home = CNPreference.shared.userPreference.homeDirectory
		let urlobj = KLURL(URL: home, context: mContext)
		return JSValue(object: urlobj, in: mContext)
	}

	public func temporaryDirectory() -> JSValue {
		let tmpurl = FileManager.default.temporaryDirectory
		let urlobj = KLURL(URL: tmpurl, context: mContext)
		return JSValue(object: urlobj, in: mContext)
	}

	private func pathString(in val: JSValue) -> String? {
		if let str = val.toString() {
			return str
		} else if let obj = val.toObject() {
			if let urlobj = obj as? KLURL {
				if let url = urlobj.url {
					return url.path
				}
			}
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
		if let pathstr = valueToString(value: pathval) {
			let fmanager = FileManager.default
			let ftype    = fmanager.checkFileType(pathString: pathstr)
			return JSValue(int32: ftype.rawValue, in: self.mContext)
		}
		return JSValue(int32: CNFileType.NotExist.rawValue, in: self.mContext)
	}

	private func valueToURL(value val: JSValue) -> URL? {
		if val.isURL {
			return val.toURL()
		} else if val.isString {
			return URL(fileURLWithPath: val.toString())
		} else {
			return nil
		}
	}

	private func valueToString(value val: JSValue) -> String? {
		if val.isURL {
			return val.toURL().path
		} else if val.isString {
			return val.toString()
		} else {
			return nil
		}
	}
}
