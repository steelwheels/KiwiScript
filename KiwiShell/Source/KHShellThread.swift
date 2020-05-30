/**
 * @file	KHShellThread.swift
 * @brief	Define KHShell class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutShell
import CoconutData
import KiwiEngine
import KiwiLibrary
import JavaScriptCore
import Foundation

@objc public protocol KHShellThreadProtocol: JSExport
{
	var  isExecuting: Bool { get }
	func start()
	func waitUntilExit() -> Int32
}

public class KHShellThreadObject: CNShellThread
{
	public enum InputMode {
		case JavaScript
		case shellScript

		public func toSymbol() -> String {
			let result: String
			switch self {
			case .JavaScript:	result = "%"
			case .shellScript:	result = ">"
			}
			return result
		}

		public static func decode(char c: Character) -> InputMode? {
			let result: InputMode?
			switch c {
			case "%":	result = .JavaScript
			case ">":	result = .shellScript
			default:	result = nil
			}
			return result
		}
	}

	private var mContext:			KEContext?
	private var mResource:			KEResource
	private var mConfig:			KEConfig
	private var mChildProcessManager:	CNProcessManager
	private var mInputMode:			InputMode

	public init(processManager procmgr: CNProcessManager, input instrm: CNFileStream, output outstrm: CNFileStream, error errstrm: CNFileStream, environment env: CNEnvironment, resource res: KEResource, config conf: KEConfig){
		mContext		= nil
		mResource		= res
		mConfig			= conf
		mChildProcessManager	= CNProcessManager()
		mInputMode		= .shellScript
		super.init(processManager: procmgr, input: instrm, output: outstrm, error: errstrm, environment: env)

		/* Allocate process manager for child processes */
		procmgr.addChildManager(childManager: mChildProcessManager)

		/* Setup built-in script location */
		let manager = KLBuiltinScripts.shared
		manager.setup(subdirectory: "Documents/Script", forClass: KHShellThreadObject.self)
	}

	public override func main(argument arg: CNNativeValue) -> Int32
	{
		guard let vm = JSVirtualMachine() else {
			console.error(string: "Failed to allocate VM\n")
			return -1
		}
		let ctxt = KEContext(virtualMachine: vm)
		mContext = ctxt

		/* Compile the context */
		let compiler  = KHShellCompiler()
		guard compiler.compileBaseAndLibrary(context:		ctxt,
						     sourceFile: 	.none,
						     processManager:	mChildProcessManager,
						     terminalInfo:	self.terminalInfo,
						     environment:	self.environment,
						     console:		self.console,
						     config: 		mConfig) else {
			console.error(string: "Failed to compile script thread context\n")
			return -1
		}

		/* Set exception handler */
		ctxt.exceptionCallback = {
			[weak self]  (_ excep: KEException) -> Void in
			if let myself = self {
				let desc = excep.description
				myself.console.error(string: "[Exception] \(desc)\n")
			}
		}

		return super.main(argument: arg)
	}

	open override func execute(command cmd: String) -> Bool {
		guard let ctxt = mContext else {
			console.error(string: "No context\n")
			return false
		}

		var result = false
		if !isEmpty(string: cmd) {
			/* decode mode */
			guard let line = decodeMode(command: cmd) else {
				return result
			}

			/* convert script */
			let parser = KHShellParser()
			switch parser.parse(lines: [line]) {
			case .ok(let stmts0):
				let stmts1  = KHCompileShellStatement(statements: stmts0)
				let script0 = KHGenerateScript(from: stmts1)
				let script1 = script0.joined(separator: "\n")
				if let retval = ctxt.evaluateScript(script1) {
					if !retval.isUndefined, let retstr = retval.toString() {
						self.outputFileHandle.write(string: retstr)
					}
					result = true
				}
			case .error(let err):
				let errobj = err as NSError
				let errmsg = errobj.toString()
				self.errorFileHandle.write(string: errmsg + "\n")
			}
		}
		return result
	}

	public override func promptString() -> String {
		return "jsh" + mInputMode.toSymbol() + " "
	}

	private func decodeMode(command cmd: String) -> String? {
		let result: String?
		let line = cmd.trimmingCharacters(in: .whitespaces)
		switch line {
		case InputMode.JavaScript.toSymbol():
			mInputMode = .JavaScript
			result = nil // do not continue
		case InputMode.shellScript.toSymbol():
			mInputMode = .shellScript
			result = nil // do not continue
		default:
			if let c = line.first {
				switch String(c) {
				case InputMode.JavaScript.toSymbol():
					var tmp = line			// Select JavaScript
					tmp.removeFirst()
					result = tmp
				case InputMode.shellScript.toSymbol():
					result = line			// Select Shell
				default:
					switch mInputMode {
					case .JavaScript:
						result = line		// Select JavaScript
					case .shellScript:
						result = "> " + line	// Select Shell
					}
				}
			} else {
				result = nil // do not cotinue
			}
		}
		return result
	}

	public override func terminate() {
		if let parent = self.processManager {
			let childlen = parent.childProcessManagers
			for child in childlen {
				NSLog("\(#file): Terminate child process")
				child.terminate()
			}
		}
	}

	private func isEmpty(string str: String) -> Bool {
		var result = true
		for c in str {
			if !c.isWhitespace {
				result = false
				break
			}
		}
		return result
	}
}

@objc public class KHShellThread: NSObject, KHShellThreadProtocol
{
	private var mThread: KHShellThreadObject

	public var isExecuting: Bool { get { return mThread.isRunning	}}

	public init(thread threadobj: KHShellThreadObject){
		mThread = threadobj
	}

	public func start() {
		mThread.start(argument: .nullValue)
	}

	public func cancel(){
		mThread.cancel()
	}

	public func waitUntilExit() -> Int32 {
		return mThread.waitUntilExit()
	}
}


