/**
 * @file	KLProcess.swift
 * @brief	Extend KLProcess class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import JavaScriptCore
import Foundation
import Darwin

@objc public protocol KLProcessProtocol: JSExport
{
	func exit(code c: Int)
}

@objc public class KLProcess: NSObject, KLProcessProtocol
{
	private var mTerminateHandler: (_ code: Int) -> Int

	public init(terminateHandler termhdl: @escaping (_ code: Int) -> Int){
		mTerminateHandler = termhdl
	}

	public func exit(code c: Int){
		let code = mTerminateHandler(c)
		exit(code: code)
	}
}

