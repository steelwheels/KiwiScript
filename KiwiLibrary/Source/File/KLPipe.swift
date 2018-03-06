/**
 * @file	KLPipe.swift
 * @brief	Define KLPipe class
 * @par Copyright
 *   Copyright (C) 2017, 2018 Steel Wheels Project
 */

import Canary
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLPipeProtocol: JSExport
{
	func open() -> JSValue
}

@objc public protocol KLPipeObjectProtocol: JSExport
{
	var input: 	JSValue { get }
	var output:	JSValue { get }
}

@objc public class KLPipe: NSObject, KLPipeProtocol
{
	private var mContext:	KEContext

	public init(context ctxt: KEContext){
		mContext = ctxt
	}

	public func open() -> JSValue {
		let pipe = KLPipeObject(context: mContext)
		return JSValue(object: pipe, in: mContext)
	}
}

@objc public class KLPipeObject: NSObject, KLPipeObjectProtocol
{
	private var mPipe:	CNPipe
	private var mContext:	KEContext
	private var mInput:	JSValue
	private var mOutput:	JSValue

	public init(context ctxt: KEContext) {
		mPipe	 = CNPipe()
		mContext = ctxt
		let input = KLFileObject(file: mPipe.inputFile, context: mContext)
		mInput = JSValue(object: input, in: mContext)
		let output = KLFileObject(file: mPipe.outputFile, context: mContext)
		mOutput = JSValue(object: output, in: mContext)
	}

	public var pipe:   CNPipe  { get { return mPipe   }}
	public var input:  JSValue { get { return mInput  }}
	public var output: JSValue { get { return mOutput }}
}
