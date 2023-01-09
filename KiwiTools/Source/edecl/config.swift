/**
 * @file	config..swift
 * @brief	Define Config class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import Cobalt
import Foundation

public class Config
{
	private var mFileNames: 	Array<String>

	public var fileNames: Array<String> { get { return mFileNames }}

	public init(fileNames names: Array<String>){
		mFileNames	= names
	}
}

public class CommandLineParser
{
	private enum OptionId: Int {
		case Help		= 0
		case Version		= 1
	}

	private var mConsole:	CNConsole

	public init(console cons: CNConsole){
		mConsole = cons
	}

	private func printUsage() {
		mConsole.print(string: "usage: edecl [options] [file-name] (option \"-h\" for help)\n")
	}

	private func printHelpMessage() {
		mConsole.print(string: "usage: adecl [options] [frame-name]\n" +
		"  [options]\n" +
		"    --help, -h         : Print this message\n" +
		"    --version          : Print version\n"
		)
	}

	public func parseArguments(arguments args: Array<String>) -> (Config, Array<String>)? {
		var config : Config? = nil
		let (err, _, rets, subargs) = CBParseArguments(parserConfig: parserConfig(), arguments: args)
		if let e = err {
			mConsole.error(string: "[Error] \(e.description)\n")
		} else {
			config = parseOptions(arguments: rets)
		}
		if let config = config {
			return (config, subargs)
		} else {
			return nil
		}
	}

	private func parseOptions(arguments args: Array<CBArgument>) -> Config? {
		let stream = CNArrayStream(source: args)
		var filenames: Array<String> = []
		while let arg = stream.get() {
			if let opt = arg as? CBOptionArgument {
				if let optid = OptionId(rawValue: opt.optionType.optionId) {
					switch optid {
					case .Help:
						printHelpMessage()
						return nil
					case .Version:
						printVersionMessage()
						return nil
					}
				} else {
					mConsole.error(string: "[Error] Unknown command line option id")
				}
			} else if let param = arg as? CBNormalArgument {
				filenames.append(param.argument)
			} else {
				mConsole.error(string: "[Error] Unknown command line parameter: \(arg)")
				return nil
			}
		}
		return Config(fileNames: filenames)
	}

	private func parserConfig() -> CBParserConfig {
		let opttypes: Array<CBOptionType> = [
			CBOptionType(optionId: OptionId.Help.rawValue,
				     shortName: "h", longName: "help",
				     parameterNum: 0, parameterType: .voidType,
				     helpInfo: "Print help message and exit program"),
			CBOptionType(optionId: OptionId.Version.rawValue,
				     shortName: nil, longName: "version",
				     parameterNum: 0, parameterType: .voidType,
				     helpInfo: "Print version information"),
		]
		let config = CBParserConfig(hasSubCommand: false)
		config.setDefaultOptions(optionTypes: opttypes)
		return config
	}

	private func printVersionMessage() {
		let plist = CNPropertyList(bundleDirectoryName: "ArisiaTools.bundle")
		let version: String
		if let v = plist.version {
			version = v
		} else {
			version = "<Unknown>"
		}
		mConsole.print(string: "\(version)\n")
	}
}
