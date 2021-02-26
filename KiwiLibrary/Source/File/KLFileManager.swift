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
	func setupFileSystem() -> JSValue

	func open(_ pathstr: JSValue, _ acctype: JSValue) -> JSValue

	func isReadable(_ pathstr: JSValue) -> JSValue
	func isWritable(_ pathstr: JSValue) -> JSValue
	func isExecutable(_ pathstr: JSValue) -> JSValue
	func isDeletable(_ pathstr: JSValue) -> JSValue
	func isAccessible(_ pathstr: JSValue, _ acctype: JSValue) -> JSValue

	func fullPath(_ path: JSValue, _ base: JSValue) -> JSValue

	#if os(OSX)
	func openPanel(_ title: JSValue, _ type: JSValue, _ exts: JSValue, _ cbfunc: JSValue)
	#endif

	func homeDirectory() -> JSValue
	func temporaryDirectory() -> JSValue

	func currentDirectory() -> JSValue
	func setCurrentDirectory(_ path: JSValue) -> JSValue

	func checkFileType(_ pathstr: JSValue) -> JSValue
	func uti(_ pathstr: JSValue) -> JSValue
}

@objc public class KLFileManager: NSObject, KLFileManagerProtocol
{
	private var mContext:			KEContext
	private var mEnvironment:		CNEnvironment
	private var mConsole:			CNFileConsole

	public init(context ctxt: KEContext, environment env: CNEnvironment, input inhdl: FileHandle, output outhdl: FileHandle, error errhdl: FileHandle){
		mContext		= ctxt
		mEnvironment		= env
		mConsole		= CNFileConsole(input: inhdl, output: outhdl, error: errhdl)
	}

	public func setupFileSystem() -> JSValue {
		let result: Bool
		if let _ = FileManager.default.setupFileSystem(console: mConsole) {
			/* There are some errors */
			result = false
		} else {
			result = true
		}
		return JSValue(bool: result, in: mContext)
	}

	public func open(_ pathval: JSValue, _ accval: JSValue) -> JSValue
	{
		guard let acctype = decodeAccessType(accval) else {
			return JSValue(nullIn: mContext)
		}

		let fmanager = FileManager.default
		if let pathstr = decodePathString(pathval) {
			let pathurl = fmanager.fullPath(pathString: pathstr, baseURL: mEnvironment.currentDirectory)
			switch fmanager.openFile(URL: pathurl, accessType: acctype) {
			case .ok(let file):
				let fileobj = KLFile(file: file, context: mContext)
				return JSValue(object: fileobj, in: mContext)
			case .error(_):
				mConsole.error(string: "Failed to write \(pathval)\n")
			@unknown default:
				mConsole.error(string: "Unknown error\n")
			}
		} else if let pathurl = decodePathURL(pathval) {
			switch fmanager.openFile(URL: pathurl, accessType: acctype) {
			case .ok(let file):
				let fileobj = KLFile(file: file, context: mContext)
				return JSValue(object: fileobj, in: mContext)
			case .error(_):
				mConsole.error(string: "Failed to write \(pathval)\n")
			@unknown default:
				mConsole.error(string: "Unknown error\n")
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
		if let pathstr = valueToString(value: pathval),
		   let accnum  = valueToInt(value: accval) {
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
			if let type = acctype {
				let result = FileManager.default.isAccessible(pathString: pathstr, accessType: type)
				return JSValue(bool: result, in: mContext)
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func fullPath(_ pathval: JSValue, _ baseval: JSValue) -> JSValue {
		if let path = valueToString(value: pathval),
		   let base = valueToURL(value: baseval) {
			let url = FileManager.default.fullPath(pathString: path, baseURL: base)
			return JSValue(object: KLURL(URL: url, context: mContext), in: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
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

	#if os(OSX)
	public func openPanel(_ titleval: JSValue, _ typeval: JSValue, _ extval: JSValue, _ cbval: JSValue)
	{
		if let title = panelTitle(title: titleval), let type = panelFileType(type: typeval), let exts = panelExtensions(extensions: extval), let cbfunc = panelCallback(callbackValue: cbval) {
			DispatchQueue.main.async {
				() -> Void in
				let urlobj: JSValue
				if let url = URL.openPanel(title: title, type: type, extensions: exts) {
					urlobj = JSValue(URL: url, in: self.mContext)
				} else {
					urlobj = JSValue(nullIn: self.mContext)
				}
				cbfunc.call(withArguments: [urlobj])
			}
		} else {
			NSLog("Invalid parameters")
		}
	}

	private func panelTitle(title tval: JSValue) -> String? {
		if tval.isString {
			if let str = tval.toString() {
				return str
			}
		}
		return nil
	}

	private func panelFileType(type tval: JSValue) -> CNFileType? {
		if let num = tval.toNumber() {
			if let sel = CNFileType(rawValue: num.int32Value) {
				return sel
			}
		}
		return nil
	}

	private func panelExtensions(extensions tval: JSValue) -> Array<String>? {
		if tval.isArray {
			var types: Array<String> = []
			if let vals = tval.toArray() {
				for elm in vals {
					if let str = elm as? String {
						types.append(str)
					} else {
						return nil
					}
				}
			}
			return types
		}
		return nil
	}

	private func panelCallback(callbackValue cbval: JSValue) -> JSValue? {
		if cbval.isUndefined {
			return nil
		} else {
			return cbval
		}
	}

	#endif

	public func homeDirectory() -> JSValue {
		let home = CNPreference.shared.userPreference.homeDirectory
		let urlobj = KLURL(URL: home, context: mContext)
		return JSValue(object: urlobj, in: mContext)
	}

	public func currentDirectory() -> JSValue {
		let dir    = mEnvironment.currentDirectory
		let urlobj = KLURL(URL: dir, context: mContext)
		return JSValue(object: urlobj, in: mContext)
	}

	public func setCurrentDirectory(_ pathval: JSValue) -> JSValue {
		let path: URL?
		let fmanager = FileManager.default
		if pathval.isURL {
			path = pathval.toURL()
		} else if pathval.isString {

			path = fmanager.fullPath(pathString: pathval.toString(), baseURL: mEnvironment.currentDirectory)
		} else {
			path = nil
		}
		if let url = path {
			/* Check the URL is accessible directry */
			var isdir    = ObjCBool(false)
			if fmanager.fileExists(atPath: url.path, isDirectory: &isdir) {
				if isdir.boolValue {
					/* Update current directory */
					mEnvironment.currentDirectory = url
					return JSValue(bool: true, in: mContext)
				}
			}
		}
		return JSValue(bool: false, in: mContext)
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

	private func valueToInt(value val: JSValue) -> Int32? {
		if val.isNumber {
			return val.toInt32()
		} else {
			return nil
		}
	}
}
