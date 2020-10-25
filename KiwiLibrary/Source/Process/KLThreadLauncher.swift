/**
 * @file	KLThreadLauncher.swift
 * @brief	Define KLThreadLauncher class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

open class KLThreadLauncher
{
	public enum SourceFile {
		case	name(String?, KEResource)	// thread-name, resource
		case	url(URL)
	}

	private var mContext:		KEContext
	private var mResource:		KEResource
	private var mProcessManager:	CNProcessManager
	private var mEnvironment:	CNEnvironment
	private var mConfig:		KEConfig

	public init(context ctxt: KEContext, resource res: KEResource, processManager procmgr: CNProcessManager, environment env: CNEnvironment, config conf: KEConfig) {
		mContext	= ctxt
		mResource	= res
		mProcessManager	= procmgr
		mEnvironment	= env
		mConfig		= conf
	}

	public func run(path pathval: JSValue,input inval: JSValue,output outval: JSValue,error errval: JSValue) -> JSValue {
		if pathval.isNull {
			#if os(OSX)
			let selector = CNFileSelector()
			if let url = selector.selectInputFile(title: "Select script file", extensions: ["js", "jspkg"]) {
				let src: SourceFile = URLtoSource(url)
				return run(source: src, input: inval, output: outval, error: errval)
			}
			#endif
		} else if let url = self.pathToFullPath(path: pathval, environment: mEnvironment) {
			let src: SourceFile = URLtoSource(url)
			return run(source: src, input: inval, output: outval, error: errval)
		}
		return JSValue(nullIn: mContext)
	}

	private func URLtoSource(_ url: URL) -> SourceFile {
		let result: SourceFile
		switch url.pathExtension {
		case "jspkg":
			let resource = KEResource(baseURL: url)
			let loader = KEManifestLoader()
			if let _ = loader.load(into: resource) {
				result = .url(url) // maybe error
			} else {
				result = .name(nil, resource)
			}
		default:
			result = .url(url)
		}
		return result
	}

	public func run(name nameval: JSValue, input inval: JSValue,output outval: JSValue,error errval: JSValue) -> JSValue {
		if nameval.isString {
			let src: SourceFile = .name(nameval.toString(), mResource)
			return run(source: src, input: inval, output: outval, error: errval)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	private func run(source src: SourceFile, input inval: JSValue,output outval: JSValue,error errval: JSValue) -> JSValue {
		if let instrm  = KLThreadLauncher.valueToFileStream(value: inval),
		   let outstrm = KLThreadLauncher.valueToFileStream(value: outval),
		   let errstrm = KLThreadLauncher.valueToFileStream(value: errval) {
			let thread = allocateThread(source: src, resource: mResource, processManager: mProcessManager, input: instrm, output: outstrm, error: errstrm, environment: mEnvironment, config: mConfig)
			let _      = mProcessManager.addProcess(process: thread)
			return JSValue(object: thread, in: mContext)
		}
		return JSValue(nullIn: mContext)
	}

	open func allocateThread(source src: SourceFile, resource res: KEResource, processManager procmgr: CNProcessManager, input instrm: CNFileStream, output outstrm: CNFileStream, error errstrm: CNFileStream, environment env: CNEnvironment, config conf: KEConfig) -> KLThread {
		let result: KLThread
		switch src {
		case .name(let name, let res):
			result = KLThread(threadName: name, resource: res, processManager: procmgr, input: instrm, output: outstrm, error: errstrm, environment: env, config: conf)
		case .url(let url):
			result = KLThread(scriptURL: url, processManager: procmgr, input: instrm, output: outstrm, error: errstrm, environment: env, config: conf)
		}
		return result
	}

	private class func valueToFileStream(value val: JSValue) -> CNFileStream? {
		if let obj = val.toObject() {
			if let file = obj as? KLFile {
				return .fileHandle(file.fileHandle)
			} else if let pipe = obj as? KLPipe {
				return .pipe(pipe.pipe)
			}
		}
		return nil
	}

	private func pathToFullPath(path pathval: JSValue, environment env: CNEnvironment) -> URL? {
		let pathstr: String
		if pathval.isURL {
			pathstr = pathval.toURL().path
		} else if pathval.isString {
			pathstr = pathval.toString()
		} else {
			return nil
		}
		if FileManager.default.isAbsolutePath(pathString: pathstr) {
			return URL(fileURLWithPath: pathstr)
		} else {
			let curdir = env.currentDirectory
			return URL(fileURLWithPath: pathstr, relativeTo: curdir)
		}
	}
}
