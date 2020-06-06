/**
 * @file	KMObjectParser.swift
 * @brief	Define KMObjectParser class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KMObjectParser
{
	public enum ParseError: Error {
		case tokenError(CNParseError)
		case unknownError
		case emptyStringError
		case notEntireParsedError
		case unexpectedEndOfStream
		case unexpectedSymbol(Character, Character, Int)	// given, required, line
		case noExpectedSymbol(Array<Character>, Int)
		case unexpectedTypeValue(CNToken, Int)
		case unexpectedToken(CNToken, Int)

		public var description: String {
			get {
				let result: String
				switch self {
				case .tokenError(let err):	result = err.description()
				case .unknownError:		result = "Unknown"
				case .emptyStringError:		result = "Empty string"
				case .notEntireParsedError:	result = "Parsing terminated"
				case .unexpectedEndOfStream:	result = "Unexpected end of source"
				case .unexpectedSymbol(let real, let exp, let line):
					result = "Unexpected symbol \(real) instead of \(exp) at line \(line)"
				case .noExpectedSymbol(let exp, let line):
					result = "Symbol \(exp) is expected at line \(line)"
				case .unexpectedToken(let token, let line):
					result = "Unexpected token \(token.toString()) at line \(line)"
				case .unexpectedTypeValue(let token, let line):
					result = "Unexpected type value \(token.toString()) at line \(line)"
				}
				return result
			}
		}
	}

	public enum Result {
		case ok(KMObject)
		case error(ParseError)
	}

	public enum DataType {
		case bool
		case int
		case float
		case string
		case custom(String)
	}

	public init(){
	}

	public func parse(source src: String) -> Result {
		/* Remove comments in the string */
		let lines = removeComments(lines: src.components(separatedBy: "\n"))
		let msrc  = lines.joined(separator: "\n")

		let conf = CNParserConfig(allowIdentiferHasPeriod: false)
		let result: Result
		switch CNStringToToken(string: msrc, config: conf) {
		case .ok(let tokens):
			do {
				if tokens.count > 0 {
					/* Parse object */
					let obj = try parseObject(tokenStream: CNTokenStream(source: tokens))
					result = .ok(obj)
				} else {
					result = .error(.emptyStringError)
				}
			} catch let err as ParseError {
				result = .error(err)
			} catch {
				result = .error(.unknownError)
			}
		case .error(let err):
			result = .error(.tokenError(err))
		}
		return result
	}

	private func removeComments(lines lns: Array<String>) -> Array<String> {
		var result: Array<String> = []
		for line in lns {
			let parts = line.components(separatedBy: "//")
			result.append(parts[0])
		}
		return result
	}

	private func decodeDataType(identifier ident: String) -> DataType {
		let result: DataType
		switch ident {
		case "bool":	result = .bool
		case "int":	result = .int
		case "float":	result = .float
		case "string":	result = .string
		default:	result = .custom(ident)
		}
		return result
	}

	private func parseObject(tokenStream stream: CNTokenStream) throws -> KMObject {
		if let token = stream.get() {
			switch token.type {
			case .SymbolToken(let c):
				if c == "{" {
					let props = try parseProperties(tokenStream: stream)
					return KMObject(properties: props)
				} else {
					throw ParseError.unexpectedSymbol(c, "{", token.lineNo)
				}
			default:
				break
			}
			throw ParseError.unexpectedToken(token, token.lineNo)
		} else {
			throw ParseError.unexpectedEndOfStream
		}
	}

	private func parseProperties(tokenStream stream: CNTokenStream) throws -> Array<KMProperty> {
		var props: Array<KMProperty> = []
		var is1st  = true
		parse_loop: while true {
			/* Require
			 *   is1st  : "}" or none
			 *   !is1st : "}" or ","
			 */
			if let token = stream.get() {
				switch token.type {
				case .SymbolToken(let c):
					if c == "}" {
						break parse_loop	/* Break out of this loop */
					} else if !is1st && c == "," {
						/* through */
					} else {
						throw ParseError.unexpectedSymbol(c, "}", token.lineNo)
					}
				default:
					if !is1st {
						throw ParseError.noExpectedSymbol([",", "}"], token.lineNo)
					} else {
						let _ = stream.unget()
					}
				}
			} else {
				throw ParseError.unexpectedEndOfStream
			}

			/* Require property */
			if let token = stream.get() {
				switch token.type {
				case .IdentifierToken(let ident):
					let prop = try parseProperty(identifier: ident, tokenStream: stream)
					props.append(prop)
				default:
					throw ParseError.unexpectedToken(token, token.lineNo)
				}
			} else {
				throw ParseError.unexpectedEndOfStream
			}
			/* Update flag */
			is1st = false
		}
		return props
	}

	private func parseProperty(identifier ident: String, tokenStream stream: CNTokenStream) throws -> KMProperty {
		if let token = stream.get() {
			switch token.type {
			case .SymbolToken(let c):
				if c == ":" {
					let val = try parseValue(tokenStream: stream)
					return KMProperty(name: ident, value: val)
				} else {
					throw ParseError.unexpectedSymbol(c, ":", token.lineNo)
				}
			default:
				throw ParseError.unexpectedToken(token, token.lineNo)
			}
		} else {
			throw ParseError.unexpectedEndOfStream
		}
	}

	private func parseValue(tokenStream stream: CNTokenStream) throws -> KMValue {
		if let token = stream.get() {
			switch token.type {
			case .IdentifierToken(let ident):
				let type = decodeDataType(identifier: ident)
				return try parseRawValue(dataType: type, tokenStream: stream)
			default:
				break
			}
			throw ParseError.unexpectedToken(token, token.lineNo)
		} else {
			throw ParseError.unexpectedEndOfStream
		}
	}
	
	private func parseRawValue(dataType type: DataType, tokenStream stream: CNTokenStream) throws -> KMValue {
		if let token = stream.get() {
			switch type {
			case .bool:
				switch token.type {
				case .BoolToken(let value):
					return .bool(value)
				default:
					throw ParseError.unexpectedTypeValue(token, token.lineNo)
				}
			case .int:
				switch token.type {
				case .IntToken(let value):
					return .int(value)
				case .UIntToken(let value):
					return .int(Int(value))
				default:
					throw ParseError.unexpectedTypeValue(token, token.lineNo)
				}
			case .float:
				switch token.type {
				case .IntToken(let value):
					return .float(Double(value))
				case .UIntToken(let value):
					return .float(Double(value))
				case .DoubleToken(let value):
					return .float(value)
				default:
					throw ParseError.unexpectedTypeValue(token, token.lineNo)
				}
			case .string:
				switch token.type {
				case .StringToken(let value):
					return .string(value)
				default:
					throw ParseError.unexpectedTypeValue(token, token.lineNo)
				}
			case .custom(let typename):
				switch token.type {
				case .SymbolToken(let c):
					if c == "{" {
						let props = try parseProperties(tokenStream: stream)
						let obj   = KMObject(properties: props)
						return KMValue.object(typename, obj)
					} else {
						throw ParseError.unexpectedSymbol(c, "{", token.lineNo)
					}
				default:
					throw ParseError.unexpectedToken(token, token.lineNo)
				}
			}
		} else {
			throw ParseError.unexpectedEndOfStream
		}
	}
}

