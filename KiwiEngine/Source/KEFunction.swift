/**
 * @file	KEFunction.swift
 * @brief	Define KEFunction protocol
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import JavaScriptCore
import Foundation

public protocol KEFunction
{
	var context:		KEContext { get }
	var sourceCode: 	String { get }
	var functionObject:	JSValue { get }
}

open class KEDefaultFunction: KEFunction
{
	private var mSourceCode:	String
	private var mFunctionObject:	JSValue
	private var mContext:		KEContext

	public var sourceCode: String 		{ get { return mSourceCode }}
	public var functionObject: JSValue	{ get { return mFunctionObject }}
	public var context: KEContext		{ get { return mContext }}

	public init(sourceCode code: String, functionObject obj: JSValue, context ctxt: KEContext){
		mSourceCode	= code
		mFunctionObject	= obj
		mContext	= ctxt
	}

	public func call(parameters params: Array<JSValue>) -> JSValue? {
		return mFunctionObject.call(withArguments: params)
	}
}

