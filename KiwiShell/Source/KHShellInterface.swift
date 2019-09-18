/**
 * @file	KHShellInterface.swift
 * @brief	Define KHShellInterface class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KHShellInterface
{
	public var	inputFileName:			String?
	public var	outputFileName:			String?
	public var	errorFileName:			String?
	public var	environmentVariableName:	String?
	public var	exitVariableName:		String?
	public var	shellStatement:			String?

	public init(){
		inputFileName		= nil
		outputFileName		= nil
		errorFileName		= nil
		environmentVariableName	= nil
		exitVariableName	= nil
		shellStatement		= nil
	}

	public func dump(to console: CNConsole) {
		let inname  = nameToString(name: inputFileName)
		let outname = nameToString(name: outputFileName)
		let errname = nameToString(name: errorFileName)
		let envname = nameToString(name: environmentVariableName)
		let extname = nameToString(name: exitVariableName)
		let shstmt  = nameToString(name: shellStatement)

		let result =   "{\n"
			     + "\tinputFileName          : \(inname)\n"
			     + "\toutputFileName         : \(outname)\n"
			     + "\terrorFileName          : \(errname)\n"
			     + "\tenviromentVariableName : \(envname)\n"
			     + "\texitVariableName       : \(extname)\n"
			     + "\tshellStatement         : \(shstmt)\n"
			     + "}\n"
		console.print(string: result)
	}

	private func nameToString(name nm: String?) -> String {
		if let name = nm {
			return name
		} else {
			return "nil"
		}
	}

	public static func parse(string str: String) -> KHShellInterface? {
		let stream = CNStringStream(string: str)
		if let (strmA, strmB) = stream.splitByFirstCharacter(characters: [">"]) {
			let result: KHShellInterface?
			let config = CNParserConfig(allowIdentiferHasPeriod: true)
			let (err, tokens) = CNStringStreamToToken(stream: strmA, config: config)
			switch err {
			case .NoError:
				if let intf = parse(tokens: tokens) {
					/* Set shell statement */
					intf.shellStatement = strmB.toString()
					result = intf
				} else {
					result = nil
				}
			case .ParseError(_, _), .TokenizeError(_, _):
				result = nil
			}
			return result
		} else {
			return nil ;	// No interface description
		}
	}

	private static func parse(tokens tkns: Array<CNToken>) -> KHShellInterface? {
		if tkns.count > 0 {
			if tkns[0].getSymbol() == "(" {
				// Search ")"
				for i in 1..<tkns.count {
					if tkns[i].getSymbol() == ")" {
						return parse(tokens: tkns, start: 1, end: i)
					}
				}
			}
			return nil
		} else { // tkns.count == 0
			return KHShellInterface()
		}
	}

	private static func parse(tokens tkns: Array<CNToken>, start sidx: Int, end eidx: Int) -> KHShellInterface? {
		let result   = KHShellInterface()
		let tokennum = tkns.count

		/* Check file arguments between ( and ) */
		let elmidx = sidx
		let elmnum = eidx - elmidx
		switch elmnum {
		case 0:
			// No parameter ()
			break
		case 1:
			// 1 parameter (A)
			if let ident = tkns[elmidx].getIdentifier() {
				result.inputFileName 			= ident
			} else {
				return nil
			}
		case 3:
			// 2 parameter (A,B)
			if tkns[elmidx+1].getSymbol() == "," {
				if let ident0 = tkns[elmidx  ].getIdentifier(),
				   let ident1 = tkns[elmidx+2].getIdentifier() {
					result.inputFileName  		= ident0
					result.outputFileName 		= ident1
				} else {
					return nil
				}
			} else {
				return nil
			}
		case 5:
			// 3 parameter (A, B, C)
			if tkns[elmidx+1].getSymbol() == "," && tkns[elmidx+3].getSymbol() == "," {
				if let ident0 = tkns[elmidx  ].getIdentifier(),
				   let ident1 = tkns[elmidx+2].getIdentifier(),
				   let ident2 = tkns[elmidx+4].getIdentifier() {
					result.inputFileName  		= ident0
					result.outputFileName 		= ident1
					result.errorFileName  		= ident2
				} else {
					return nil
				}
			} else {
				return nil
			}
		case 7:
			// 4 parameter (A, B, C, D)
			if tkns[elmidx+1].getSymbol() == "," && tkns[elmidx+3].getSymbol() == "," && tkns[elmidx+5].getSymbol() == "," {
				if let ident0 = tkns[elmidx  ].getIdentifier(),
					let ident1 = tkns[elmidx+2].getIdentifier(),
					let ident2 = tkns[elmidx+4].getIdentifier(),
					let ident3 = tkns[elmidx+6].getIdentifier() {
					result.inputFileName  		= ident0
					result.outputFileName 		= ident1
					result.errorFileName  		= ident2
					result.environmentVariableName	= ident3
				} else {
					return nil
				}
			} else {
				return nil
			}
		default:
			// Invalid parameter num
			return nil
		}

		/* Check return value after : */
		let nextidx = eidx + 1
		if nextidx == tokennum {
			// no return values
			return result
		} else if nextidx + 2 == tokennum {
			// has ":" and "exitval"
			if tkns[nextidx].getSymbol() == ":" {
				if let exitval = tkns[nextidx + 1].getIdentifier() {
					result.exitVariableName = exitval
					return result
				}
			}
			// has unknown parameters
			return nil
		} else {
			// has unknown parameters
			return nil
		}
	}
}
