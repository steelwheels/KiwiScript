/**
 * @file	KLPipe.swift
 * @brief	Define KLPipe class
 * @par Copyright
 *   Copyright (C) 2017, 2018 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLPipeProtocol: JSExport
{
	var input: 	JSValue { get }
	var output:	JSValue { get }
}

@objc public class KLPipe: NSObject, KLPipeProtocol
{
	private var mPipe:	Pipe
	private var mContext:	KEContext
	private var mInput:	KLFile?
	private var mOutput:	KLFile?

	public init(context ctxt: KEContext){
		mPipe    = Pipe()
		mContext = ctxt
		mInput   = nil
		mOutput	 = nil
	}

	public var input: JSValue {
		get {
			if let file = mInput {
				return JSValue(object: file, in: mContext)
			} else {
				let newfile = CNTextFileObject(fileHandle: mPipe.fileHandleForReading)
				let fileobj = KLFile(file: newfile, context: mContext)
				mInput = fileobj
				return JSValue(object: fileobj, in: mContext)
			}
		}
	}

	public var output: JSValue {
		get {
			if let file = mOutput {
				return JSValue(object: file, in: mContext)
			} else {
				let newfile = CNTextFileObject(fileHandle: mPipe.fileHandleForWriting)
				let fileobj = KLFile(file: newfile, context: mContext)
				mInput = fileobj
				return JSValue(object: fileobj, in: mContext)
			}
		}
	}
}

