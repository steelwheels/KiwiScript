/**
 * @file	KHShell.swift
 * @brief	Define KHShell class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutShell
import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KHShellProtocol: JSExport
{
	//var  prompt:		JSValue { get set }
	var  isExecuting:	Bool { get }

	func start()
}

@objc public class KHShell: CNShell, KHShellProtocol
{
	public static let EnvironmentItem	= "_env"

	private var mContext: 		KEContext

	public init(context ctxt: KEContext, shellInterface intf: CNShellInterface, environment env: CNShellEnvironment, console cons: CNConsole, config conf: KEConfig){
		mContext 	= ctxt
		super.init(interface: intf, environment: env, console: cons, config: conf)
	}

	public override func promptString() -> String {
		return "jsh$ "
	}

	public override func start(){
		if !super.isExecuting {
			super.start()
		}
	}
}


