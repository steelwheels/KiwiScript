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

	private var mContext:		KEContext
	private var mInputMode:		InputMode

	public var context: KEContext { get { return mContext }}

	public init(virtualMachine vm: JSVirtualMachine, queue disque: DispatchQueue, resource res: KEResource, input instrm: CNFileStream, output outstrm: CNFileStream, error errstrm: CNFileStream, config conf: KEConfig){
		mContext	= KEContext(virtualMachine: vm)
		mInputMode	= .shellScript
		super.init(queue: disque, input: instrm, output: outstrm, error: errstrm, config: conf)

		/* Compile the context */
		let shellconf = KEConfig(kind: .Terminal, doStrict: conf.doStrict, logLevel: conf.logLevel)
		let compiler  = KHShellCompiler()
		guard compiler.compileBaseAndLibrary(context: mContext, queue: disque, resource: res, console: console, terminalInfo: self.terminalInfo, config: shellconf) else {
			console.error(string: "Failed to compile script thread context\n")
			return
		}
		/* Set exception handler */
		mContext.exceptionCallback = {
			[weak self]  (_ excep: KEException) -> Void in
			if let myself = self {
				let desc = excep.description
				myself.console.error(string: "[Exception] \(desc)\n")
			}
		}
	}

	public override func promptString() -> String {
		return "jsh" + mInputMode.toSymbol() + " "
	}

	open override func execute(command cmd: String){
		if !isEmpty(string: cmd) {
			/* decode mode */
			guard let line = decodeMode(command: cmd) else {
				return
			}

			/* convert script */
			let translator = KHShellTranslator()
			switch translator.translate(lines: [line]) {
			case .ok(let lines):
				let script = lines.joined(separator: "\n")
				if let retval = mContext.evaluateScript(script) {
					if !retval.isUndefined, let retstr = retval.toString() {
						self.outputFileHandle.write(string: retstr)
					}
				}
			case .error(let err):
				let errobj = err as NSError
				let errmsg = errobj.toString()
				self.errorFileHandle.write(string: errmsg + "\n")
			}
		}
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

	public init(virtualMachine vm: JSVirtualMachine, queue disque: DispatchQueue, resource res: KEResource, input instrm: CNFileStream, output outstrm: CNFileStream, error errstrm: CNFileStream, config conf: KEConfig){
		mThread = KHShellThreadObject(virtualMachine: vm, queue: disque, resource: res, input: instrm, output: outstrm, error: errstrm, config: conf)
	}

	public func start() {
		mThread.start(arguments: [])
	}

	public func cancel(){
		mThread.cancel()
	}

	public func waitUntilExit() -> Int32 {
		return mThread.waitUntilExit()
	}
}


/*

@objc public class KHShellThread: CNShellThread, KHShellThreadProtocol
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

	private var mContext:		KEContext
	private var mInputMode:		InputMode

	public init(virtualMachine vm: JSVirtualMachine, resource res: KEResource, input instrm: CNFileStream, output outstrm: CNFileStream, error errstrm: CNFileStream, config conf: KEConfig){
		mContext	= KEContext(virtualMachine: vm)
		mInputMode	= .shellScript
		super.init(input: instrm, output: outstrm, error: errstrm, config: conf, terminationHander: nil)

		/* Compile the context */
		let shellconf = KEConfig(kind: .Terminal, doStrict: conf.doStrict, logLevel: conf.logLevel)
		let compiler  = KHShellCompiler()
		guard compiler.compileBaseAndLibrary(context: mContext, resource: res, console: console, terminalInfo: self.terminalInfo, config: shellconf) else {
			console.error(string: "Failed to compile script thread context\n")
			return
		}
		/* Set exception handler */
		mContext.exceptionCallback = {
			[weak self]  (_ excep: KEException) -> Void in
			if let myself = self {
				let desc = excep.description
				myself.console.error(string: "[Exception] \(desc)\n")
			}
		}
	}

	public override func promptString() -> String {
		return "jsh" + mInputMode.toSymbol() + " "
	}

	open override func execute(command cmd: String){
		if !isEmpty(string: cmd) {
			/* decode mode */
			guard let line = decodeMode(command: cmd) else {
				return
			}

			/* convert script */
			let translator = KHShellTranslator()
			switch translator.translate(lines: [line]) {
			case .ok(let lines):
				let script = lines.joined(separator: "\n")
				if let retval = mContext.evaluateScript(script) {
					if !retval.isUndefined, let retstr = retval.toString() {
						self.outputFileHandle.write(string: retstr)
					}
				}
			case .error(let err):
				let errobj = err as NSError
				let errmsg = errobj.toString()
				self.errorFileHandle.write(string: errmsg + "\n")
			}
		}
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

*/

