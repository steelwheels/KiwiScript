/**
 * @file	KMFunction.swift
 * @brief	Define KMFunction protocol
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public protocol KMFunction
{
	var context:		KEContext { get }
	var sourceCode: 	String { get }
	var functionObject:	JSValue { get }
}

open class KMDefaultFunction: KMFunction
{
	private var mSourceCode:	String
	private var mFunctionObject:	JSValue
	private var mContext:		KEContext
	private var mConsole:		CNConsole

	public var sourceCode: String 		{ get { return mSourceCode }}
	public var functionObject: JSValue	{ get { return mFunctionObject }}
	public var context: KEContext		{ get { return mContext }}

	public init(sourceCode code: String, functionObject obj: JSValue, context ctxt: KEContext, console cons: CNConsole){
		mSourceCode	= code
		mFunctionObject	= obj
		mContext	= ctxt
		mConsole	= cons
	}

	public func call(parameters params: Array<JSValue>) -> JSValue? {
		return mFunctionObject.call(withArguments: params)
	}

	public func log(message msg: String){
		mConsole.print(string: msg + "\n")
	}

	public func error(message msg: String){
		mConsole.print(string: msg + "\n")
	}
}

