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
	var reading: 	JSValue { get }
	var writing:	JSValue { get }
}

@objc public class KLPipe: NSObject, KLPipeProtocol
{
	private var mPipe:	Pipe
	private var mContext:	KEContext
	private var mWriting:	KLFile?
	private var mReading:	KLFile?

	public init(context ctxt: KEContext){
		mPipe    = Pipe()
		mContext = ctxt
		mWriting = nil
		mReading = nil
	}

	public var pipe: Pipe { get { return mPipe }}

	public var reading: JSValue {
		get {
			if let file = mReading {
				return JSValue(object: file, in: mContext)
			} else {
				let newfile = CNTextFileObject(fileHandle: mPipe.fileHandleForReading)
				let fileobj = KLFile(file: newfile, context: mContext)
				mReading = fileobj
				return JSValue(object: fileobj, in: mContext)
			}
		}
	}

	public var writing: JSValue {
		get {
			if let file = mWriting {
				return JSValue(object: file, in: mContext)
			} else {
				let newfile = CNTextFileObject(fileHandle: mPipe.fileHandleForWriting)
				let fileobj = KLFile(file: newfile, context: mContext)
				mWriting = fileobj
				return JSValue(object: fileobj, in: mContext)
			}
		}
	}
}

