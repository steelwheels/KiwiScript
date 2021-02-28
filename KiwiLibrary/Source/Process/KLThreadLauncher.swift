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
			if let url = URL.openPanel(title: "Select script file", type: .File, extensions: ["js", "jspkg"]) {
				let src: KLSource = .script(url)
				return run(source: src, input: inval, output: outval, error: errval)
			}
			#endif
		} else if let url = self.pathToFullPath(path: pathval, environment: mEnvironment) {
			let src: KLSource = .script(url)
			return run(source: src, input: inval, output: outval, error: errval)
		}
		return JSValue(nullIn: mContext)
	}

	public func run(name nameval: JSValue, input inval: JSValue,output outval: JSValue,error errval: JSValue) -> JSValue {
		if nameval.isString {
			if let url = mResource.URLOfThread(identifier: nameval.toString()) {
				return run(source: .script(url), input: inval, output: outval, error: errval)
			}
		}
		return JSValue(nullIn: mContext)
	}

	private func run(source src: KLSource, input inval: JSValue,output outval: JSValue,error errval: JSValue) -> JSValue {
		if let instrm  = KLThreadLauncher.valueToFileStream(value: inval),
		   let outstrm = KLThreadLauncher.valueToFileStream(value: outval),
		   let errstrm = KLThreadLauncher.valueToFileStream(value: errval) {
			let thread = allocateThread(source: src, processManager: mProcessManager, input: instrm, output: outstrm, error: errstrm, environment: mEnvironment, config: mConfig)
			let _      = mProcessManager.addProcess(process: thread)
			return JSValue(object: thread, in: mContext)
		}
		return JSValue(nullIn: mContext)
	}

	open func allocateThread(source src: KLSource, processManager procmgr: CNProcessManager, input instrm: CNFileStream, output outstrm: CNFileStream, error errstrm: CNFileStream, environment env: CNEnvironment, config conf: KEConfig) -> KLThread {
		let result = KLThread(source: src, processManager: procmgr, input: instrm, output: outstrm, error: errstrm, environment: env, config: conf)
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
