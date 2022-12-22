/**
 * @file	KLScriptValue.swift
 * @brief	Extend JSValue class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

private var temp_record_id: UInt = 0

extension JSValue
{
	public static let instancePropertyName: String	= "instanceName"

	public convenience init(URL url: URL, in context: KEContext) {
		let urlobj = KLURL(URL: url, context: context)
		self.init(object: urlobj, in: context)
	}

	public convenience init(image img: CNImage, in context: KEContext) {
		let imgobj = KLImage(context: context)
		imgobj.coreImage = img
		self.init(object: imgobj, in: context)
	}

	public static func hasClassName(value val: JSValue, className name: String) -> Bool {
		if let dict = val.toObject() as? Dictionary<String, Any> {
			if let str = dict["class"] as? String {
				return str == name
			}
		}
		return false
	}

	public var isDictionary: Bool {
		get {
			if let _ = self.toDictionary()	{
				return true
			} else {
				return false
			}
		}
	}

	public var isSet: Bool { get {
		return CNValueSet.isSet(scriptValue: self)
	}}

	public func toSet() -> CNValue? {
		return CNValueSet.fromJSValue(scriptValue: self)
	}

	public var isPoint: Bool {
		get { return CGPoint.isPoint(scriptValue: self) }
	}

	public var isSize: Bool {
		get { return CGSize.isSize(scriptValue: self) }
	}

	public var isRect: Bool {
		get { return CGRect.isRect(scriptValue: self) }
	}

	public var isRange: Bool {
		get { return NSRange.isRange(scriptValue: self) }
	}

	public var isEnum: Bool {
		get { return CNEnum.isEnum(scriptValue: self) }
	}

	public func toEnum() -> CNEnum? {
		return CNEnum.fromJSValue(scriptValue: self)
	}

	public var isURL: Bool {
		get {
			if let urlobj = self.toObject() as? KLURL {
				if let _ = urlobj.url {
					return true
				}
			}
			return false
		}
	}

	public func toURL() -> URL? {
		if let urlobj = self.toObject() as? KLURL {
			if let url = urlobj.url {
				return url
			}
		}
		return nil
	}

	public var isImage: Bool { get {
		if let imgobj = self.toObject() as? KLImage {
			if let _ = imgobj.coreImage {
				return true
			}
		}
		return false
	}}

	public func toImage() -> CNImage? {
		if let imgobj = self.toObject() as? KLImage {
			if let img = imgobj.coreImage {
				return img
			}
		}
		return nil
	}

	public var isRecord: Bool { get {
		if let _ = self.toObject() as? KLRecord {
			return true
		} else {
			return false
		}
	}}

	public func toRecord() -> CNRecord? {
		if let recobj = self.toObject() as? KLRecordCoreProtocol {
			return recobj.core()
		} else {
			return nil
		}
	}

	public var isColor: Bool {
		get {
			if let _ = self.toObject() as? KLColor {
				return true
			}
			return false
		}
	}

	public func toColor() -> CNColor? {
		if let colobj = self.toObject() as? KLColor {
			return colobj.core
		}
		return nil
	}

	public var isSegment: Bool {
		get { return CNValueSegment.isValueSegment(scriptValue: self) }
	}

	public func toSegment() -> CNValueSegment? {
		return CNValueSegment.fromJSValue(scriptValue: self)
	}

	public var isPointer: Bool {
		get { return CNPointerValue.isPointer(scriptValue: self) }
	}

	public func toPointer() -> CNPointerValue? {
		switch CNPointerValue.fromJSValue(scriptValue: self) {
		case .success(let val):
			return val
		case .failure(let err):
			CNLog(logLevel: .error, message: err.toString(), atFunction: #function, inFile: #file)
			return nil
		}
	}

	private func anyToDouble(any aval: Any?) -> CGFloat? {
		if let val = aval as? CGFloat {
			return val
		} else if let val = aval as? Double {
			return CGFloat(val)
		} else if let val = aval as? NSNumber {
			return CGFloat(val.floatValue)
		} else {
			return nil
		}
	}

	private func anyToInt(any aval: Any?) -> Int? {
		if let val = aval as? Int {
			return val
		} else if let val = aval as? NSNumber {
			return val.intValue
		} else {
			return nil
		}
	}

	private func anyToString(any aval: Any?) -> String? {
		if let val = aval as? String {
			return val
		} else {
			return nil
		}
	}

	public var type: CNValueType? { get {
		var result: CNValueType?
		if self.isUndefined {
			result = nil
		} else if self.isNull {
			result = .objectType(nil)
		} else if self.isBoolean {
			result = .boolType
		} else if self.isNumber {
			result = .numberType
		} else if self.isString {
			result = .stringType
		} else if self.isArray {
			result = .arrayType(.anyType)
		} else if self.isSet {
			result = .setType(.anyType)
		} else if self.isDictionary {
			result = .dictionaryType(.anyType)
		} else if self.isObject {
			if let _ = self.toObject() as? Dictionary<AnyHashable, Any> {
				result = .dictionaryType(.anyType)
			} else {
				result = .objectType(nil)
			}
		} else {
			fatalError("Unknown type: \"\(self.description)\"")
		}
		return result
	}}

	public func toScript() -> CNText {
		let converter = KLScriptValueToNativeValue()
		let native    = converter.convert(scriptValue: self)
		return native.toScript()
	}
}

public class KLScriptValueToNativeValue
{
	public init() {
	}

	public func convert(scriptValue src: JSValue) -> CNValue {
		let result: CNValue
		if let type = src.type {
			switch type {
			case .anyType, .voidType, .functionType(_, _), .interfaceType(_):
				CNLog(logLevel: .error, message: "Can not assign native value", atFunction: #function, inFile: #file)
				result = CNValue.null
			case .boolType:
				result = .boolValue(src.toBool())
			case .numberType:
				result = .numberValue(src.toNumber())
			case .stringType:
				result = .stringValue(src.toString())
			case .enumType:
				result = convert(enumValue: src.toEnum())
			case .arrayType:
				result = convert(arrayValue: src.toArray())
			case .setType:
				result = convert(setValue: src)
			case .dictionaryType:
				result = convert(dictionaryValue: src.toDictionary())
			case .objectType:
				if let obj = src.toObject() {
					result = .objectValue(obj as AnyObject)
				} else {
					CNLog(logLevel: .error, message: "Failed to convert to Object", atFunction: #function, inFile: #file)
					result = CNValue.null
				}
			@unknown default:
				CNLog(logLevel: .error, message: "Unknown case", atFunction: #function, inFile: #file)
				result = CNValue.null
			}
		} else {
			result = CNValue.null
		}
		return result
	}

	public func convert(arrayValue src: Array<Any>) -> CNValue {
		var result: Array<CNValue> = []
		let converter = CNAnyObjecToValue()
		for elm in src {
			let nval = converter.convert(anyObject: elm as AnyObject)
			result.append(nval)
		}
		return .arrayValue(result)
	}

	public func convert(dictionaryValue src: Dictionary<AnyHashable, Any>) -> CNValue {
		let converter = CNAnyObjecToValue()
		var newdict: Dictionary<String, CNValue> = [:]
		for (hash, val) in src {
			if let key = hash as? String  {
				newdict[key] = converter.convert(anyObject: val as AnyObject)
			} else {
				CNLog(logLevel: .error, message: "Unexpected dictionary item: key=\(hash), value=\(val)", atFunction: #function, inFile: #file)
			}
		}
		let result: CNValue
		if let scalar = CNDictionaryToValue(dictionary: newdict) {
			result = scalar
		} else {
			result = .dictionaryValue(newdict)
		}
		return result
	}

	public func convert(setValue src: JSValue) -> CNValue {
		let result: CNValue
		if let val = CNValueSet.fromJSValue(scriptValue: src) {
			result = val
		} else {
			CNLog(logLevel: .error, message: "Failed to convert to set", atFunction: #function, inFile: #file)
			result = CNValue.null
		}
		return result
	}

	public func convert(enumValue src: CNEnum?) -> CNValue {
		let result: CNValue
		if let eval = src {
			result = CNValue.enumValue(eval)
		} else {
			result = CNValue.null
		}
		return result
	}
}
