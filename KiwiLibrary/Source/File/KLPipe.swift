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
	private var mPipe:	CNPipe
	private var mContext:	KEContext
	private var mWriting:	KLFile?
	private var mReading:	KLFile?

	public init(context ctxt: KEContext){
		mPipe    = CNPipe()
		mContext = ctxt
		mWriting = nil
		mReading = nil
	}

	public var pipe: Pipe { get { return mPipe.pipe }}

	public var readerFile: CNFile { get { return mPipe.reader }}
	public var writerFile: CNFile { get { return mPipe.writer }}

	public var reading: JSValue {
		get {
			if let file = mReading {
				return JSValue(object: file, in: mContext)
			} else {
				let fileobj = KLFile(file: self.readerFile, context: mContext)
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
				let fileobj = KLFile(file: self.writerFile, context: mContext)
				mWriting = fileobj
				return JSValue(object: fileobj, in: mContext)
			}
		}
	}
}

