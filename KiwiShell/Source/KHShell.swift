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
	public init(shellInterface intf: CNShellInterface, console cons: CNConsole){
		super.init(interface: intf, console: cons)
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


