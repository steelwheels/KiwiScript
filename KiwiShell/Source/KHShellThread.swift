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

open class KHShellThread: CNShellThread
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

	private var mContext:			KEContext
	private var mResource:			KEResource
	private var mConfig:			KEConfig
	private var mChildProcessManager:	CNProcessManager
	private var mInputMode:			InputMode

	public init(processManager procmgr: CNProcessManager, input instrm: CNFileStream, output outstrm: CNFileStream, error errstrm: CNFileStream, environment env: CNEnvironment, config conf: KEConfig){
		guard let vm = JSVirtualMachine() else {
			fatalError("Failed to allocate VM")
		}
		mContext		= KEContext(virtualMachine: vm)
		mResource		= KEResource(baseURL: Bundle.main.bundleURL)
		mConfig			= conf
		mChildProcessManager	= CNProcessManager()
		mInputMode		= .shellScript
		super.init(processManager: procmgr, input: instrm, output: outstrm, error: errstrm, environment: env)

		/* Update current directory to home */
		let curdir = CNPreference.shared.userPreference.homeDirectory
		if !curdir.isNull {
			FileManager.default.changeCurrentDirectoryPath(curdir.path)
		}

		/* Allocate process manager for child processes */
		procmgr.addChildManager(childManager: mChildProcessManager)

		/* Setup built-in script location */
		let manager = KLBuiltinScripts.shared
		manager.setup(subdirectory: "Documents/Script", forClass: KHShellThread.self)
	}

	public override func main(argument arg: CNNativeValue) -> Int32
	{
		/* Compile the context */
		guard compile(context: mContext, resource: mResource, processManager: mChildProcessManager, terminalInfo: self.terminalInfo, environment: self.environment, console: self.console, config: mConfig) else {
			console.error(string: "Failed to compile\n")
			return -1
		}

		/* Compile the .jshrc file */
		let rcdir  = CNPreference.shared.userPreference.homeDirectory
		let rcfile = URL(fileURLWithPath: ".jshrc", relativeTo: rcdir)
		if FileManager.default.isReadableFile(atPath: rcfile.path) {
			if let content = rcfile.loadContents() {
				let compiler = KECompiler()
				let _ = compiler.compile(context: mContext, statement: content as String, console: self.console, config: mConfig)
			}
		}

		/* Set exception handler */
		mContext.exceptionCallback = {
			[weak self]  (_ excep: KEException) -> Void in
			if let myself = self {
				let desc = excep.description
				myself.console.error(string: "[Exception] \(desc)\n")
			}
		}

		return super.main(argument: arg)
	}

	open func compile(context ctxt: KEContext, resource res: KEResource, processManager procmgr: CNProcessManager, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, console cons: CNFileConsole, config conf: KEConfig) -> Bool {
		let libcompiler = KLLibraryCompiler()
		if libcompiler.compile(context: ctxt, resource: res, processManager: procmgr, terminalInfo: terminfo, environment: env, console: cons, config: conf) {
			let shellcompiler = KHShellCompiler()
			return shellcompiler.compile(context: ctxt, resource: res, processManager: procmgr, terminalInfo: terminfo, console: cons, environment: env, config: conf)
		} else {
			return false
		}
	}

	open override func execute(command cmd: String) {
		if !isEmpty(string: cmd) {
			/* decode mode */
			guard let line = decodeMode(command: cmd) else {
				return
			}

			/* convert script */
			let parser = KHShellParser()
			switch parser.parse(lines: [line]) {
			case .ok(let stmts0):
				/* Execute as main thread */
				let stmts1  = KHCompileShellStatement(statements: stmts0)
				let script0 = KHGenerateScript(from: stmts1)
				let script1 = script0.joined(separator: "\n")
				if let retval = self.mContext.evaluateScript(script1) {
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

	private var mUseablePromptFunc = true

	public override func promptString() -> String {
		var promptstr: String = "jsh"
		if mUseablePromptFunc {
			/* Call JavaScript function which is defined at Preference.shell.prompt */
			let pref = CNPreference.shared.shellPreference
			if let pval = pref.prompt {
				mUseablePromptFunc = false
				if let retval = pval.call(withArguments: []) {
					if retval.isString {
						promptstr = retval.toString()
						mUseablePromptFunc = true
					}
				}
			}
		}
		return promptstr + mInputMode.toSymbol() + " "
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
				//NSLog("\(#file): Terminate child process")
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


