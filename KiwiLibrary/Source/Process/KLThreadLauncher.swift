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
	private var mTerminalInfo:	CNTerminalInfo
	private var mEnvironment:	CNEnvironment
	private var mConfig:		KEConfig

	public init(context ctxt: KEContext, resource res: KEResource, processManager procmgr: CNProcessManager, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, config conf: KEConfig) {
		mContext	= ctxt
		mResource	= res
		mProcessManager	= procmgr
		mTerminalInfo	= terminfo
		mEnvironment	= env
		mConfig		= conf
	}

	public func run(path pathval: JSValue,input inval: JSValue,output outval: JSValue,error errval: JSValue) -> JSValue {
		if let path   = self.pathToFullPath(path: pathval, environment: mEnvironment),
		   let ifile  = KLThreadLauncher.valueToInputFile(value: inval),
		   let ofile  = KLThreadLauncher.valueToOutputFile(value: outval),
		   let efile  = KLThreadLauncher.valueToOutputFile(value: errval) {
			let thread = allocateThread(source: .script(path), processManager: mProcessManager, input: ifile, output: ofile, error: efile, terminalInfo: mTerminalInfo, environment: mEnvironment, config: mConfig)
			let _      = mProcessManager.addProcess(process: thread)
			return JSValue(object: thread, in: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	open func allocateThread(source src: KLSource, processManager procmgr: CNProcessManager, input ifile: CNFile, output ofile: CNFile, error efile: CNFile, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, config conf: KEConfig) -> KLThread {
		let result = KLThread(source: src, processManager: procmgr, input: ifile, output: ofile, error: efile, terminalInfo: terminfo, environment: env, config: conf)
		return result
	}

	private class func valueToInputFile(value val: JSValue) -> CNFile? {
		if let obj = val.toObject() {
			if let file = obj as? KLFile {
				return file.file
			} else if let pipe = obj as? KLPipe {
				return pipe.readerFile
			}
		}
		return nil
	}

	private class func valueToOutputFile(value val: JSValue) -> CNFile? {
		if let obj = val.toObject() {
			if let file = obj as? KLFile {
				return file.file
			} else if let pipe = obj as? KLPipe {
				return pipe.writerFile
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
