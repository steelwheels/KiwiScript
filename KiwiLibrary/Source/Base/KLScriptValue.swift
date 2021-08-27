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

extension JSValue
{
	public static let classPropertyName: String	= "className"
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

	public var classPropertyName: String? {
		if let dict = self.toObject() as? Dictionary<AnyHashable, Any> {
			if let name = dict[JSValue.classPropertyName] as? String {
				return name
			}
		}
		return nil
	}

	public func isClass(name nm: String) -> Bool {
		if let thisname = classPropertyName {
			return (thisname == nm)
		} else {
			return false
		}
	}

	public var isPoint: Bool {
		get {
			return isSpecialDictionary(keys: ["x", "y"])
		}
	}

	public func toPoint() -> CGPoint? {
		if let dict = self.toObject() as? Dictionary<AnyHashable, Any> {
			if let xval = anyToDouble(any: dict["x"]), let yval = anyToDouble(any: dict["y"]) {
				return CGPoint(x: xval, y: yval)
			}
		}
		return nil
	}

	public var isSize: Bool {
		get {
			return isSpecialDictionary(keys: ["width", "height"])
		}
	}

	public func toSize() -> CGSize? {
		if let dict = self.toObject() as? Dictionary<AnyHashable, Any> {
			if let wval = anyToDouble(any: dict["width"]), let hval = anyToDouble(any: dict["height"]) {
				return CGSize(width: wval, height: hval)
			}
		}
		return nil
	}

	public var isRect: Bool {
		get {
			return isSpecialDictionary(keys: ["x", "y", "width", "height"])
		}
	}

	public func toRect() -> CGRect? {
		if let dict = self.toObject() as? Dictionary<AnyHashable, Any> {
			if let x = anyToDouble(any: dict["x"]), let y = anyToDouble(any: dict["y"]), let width = anyToDouble(any: dict["width"]), let height = anyToDouble(any: dict["height"]) {
				return CGRect(x: x, y: y, width: width, height: height)
			}
		}
		return nil
	}

	public var isRange: Bool {
		get {
			let obj = self.toObject()
			if let _ = obj as? NSRange {
				return true
			} else {
				return isSpecialDictionary(keys: ["location", "length"])
			}
		}
	}

	public func toRange() -> NSRange? {
		if let range = self.toObject() as? NSRange {
			return range
		} else if let dict = self.toObject() as? Dictionary<AnyHashable, Any> {
			if let locval = anyToInt(any: dict["location"]), let lenval = anyToInt(any: dict["length"]) {
				return NSRange(location: locval, length: lenval)
			}
		}
		return nil
	}

	public var isEnum: Bool {
		get {
			if let dict = self.toObject() as? Dictionary<AnyHashable, Any> {
				if let _ = anyToString(any: dict["name"]), let _ = anyToInt(any: dict["value"]) {
					return true
				}
			}
			return false
		}
	}

	public func toEnum() -> Dictionary<String, CNNativeValue> {
		if let dict = self.toObject() as? Dictionary<AnyHashable, Any> {
			if let name = anyToString(any: dict["name"]), let value = anyToInt(any: dict["value"]) {
				let dict: Dictionary<String, CNNativeValue> = [
					"name":  CNNativeValue.stringValue(name),
					"value": CNNativeValue.numberValue(NSNumber(integerLiteral: value))
				]
				return dict
			}
		}
		CNLog(logLevel: .error, message: "Failed to convert to Enum", atFunction: #function, inFile: #file)
		return [:]
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

	public func toURL() -> URL {
		if let urlobj = self.toObject() as? KLURL {
			if let url = urlobj.url {
				return url
			}
		}
		CNLog(logLevel: .error, message: "Failed to convert to URL", atFunction: #function, inFile: #file)
		return URL(string: "file:/dev/null")!
	}

	public var isImage: Bool {
		get {
			if let imgobj = self.toObject() as? KLImage {
				if let _ = imgobj.coreImage {
					return true
				}
			}
			return false
		}
	}

	public func toImage() -> CNImage {
		if let imgobj = self.toObject() as? KLImage {
			if let img = imgobj.coreImage {
				return img
			}
		}
		CNLog(logLevel: .error, message: "Failed to convert to image", atFunction: #function, inFile: #file)
		return CNImage(data: Data(capacity: 16))!
	}

	public func toColor() -> CNColor {
		if let colobj = self.toObject() as? KLColor {
			return colobj.core
		}
		CNLog(logLevel: .error, message: "Failed to convert to color", atFunction: #function, inFile: #file)
		return CNColor.black
	}

	private func isSpecialDictionary(keys dictkeys: Array<AnyHashable>) -> Bool {
		if let obj = self.toObject() {
			if let dict = obj as? Dictionary<AnyHashable, Any> {
				return isSpecialDictionary(keys: dictkeys, in: dict)
			}
		}
		return false
	}

	private func isSpecialDictionary(keys dictkeys: Array<AnyHashable>, in dict: Dictionary<AnyHashable, Any>) -> Bool {
		if dict.count == dictkeys.count {
			var haskey = true
			for key in dictkeys {
				if dict[key] == nil {
					haskey = false
					break
				}
			}
			if haskey {
				return true
			}
		}
		return false
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

	public var type: CNNativeType? {
		get {
			var result: CNNativeType?
			if self.isUndefined {
				result = nil
			} else if self.isNull {
				result = .nullType
			} else if self.isBoolean {
				result = .boolType
			} else if self.isNumber {
				result = .numberType
			} else if self.isString {
				result = .stringType
			} else if self.isArray {
				result = .arrayType
			} else if self.isDate {
				result = .dateType
			} else if self.isRange {
				result = .rangeType
			} else if self.isPoint {
				result = .pointType
			} else if self.isSize {
				result = .sizeType
			} else if self.isRect {
				result = .rectType
			} else if self.isURL {
				result = .URLType
			} else if self.isImage {
				result = .imageType
			} else if self.isObject {
				if let _ = self.toObject() as? Dictionary<AnyHashable, Any> {
					result = .dictionaryType
				} else if let _ = self.toObject() as? NSRange {
					result = .rangeType
				} else {
					result = .objectType
				}
			} else {
				fatalError("Unknown type: \"\(self.description)\"")
			}
			return result
		}
	}
	
	public func toNativeValue() -> CNNativeValue {
		let result: CNNativeValue
		if let type = self.type {
			switch type {
			case .nullType:
				result = .nullValue
			case .boolType:
				result = .boolValue(self.toBool())
			case .numberType:
				result = .numberValue(self.toNumber())
			case .stringType:
				result = .stringValue(self.toString())
			case .dateType:
				result = .dateValue(self.toDate())
			case .URLType:
				result = .URLValue(self.toURL())
			case .imageType:
				result = .imageValue(self.toImage())
			case .colorType:
				result = .colorValue(self.toColor())
			case .enumType:
				let dict = self.toEnum()
				if let name = dict["name"], let val = dict["value"] {
					if let key = name.toString(), let num = val.toNumber() {
						result = CNNativeValue.enumValue(key, num.int32Value)
					} else {
						CNLog(logLevel: .error, message: "Failed to convert to Enum", atFunction: #function, inFile: #file)
						result = .nullValue
					}
				} else {
					CNLog(logLevel: .error, message: "Failed to convert to Enum", atFunction: #function, inFile: #file)
					result = .nullValue
				}
			case .rangeType:
				result = .rangeValue(self.toRange())
			case .pointType:
				if let point = self.toPoint() {
					result = .pointValue(point)
				} else {
					CNLog(logLevel: .error, message: "Failed to convert to Point", atFunction: #function, inFile: #file)
					result = .nullValue
				}
			case .sizeType:
				if let size = self.toSize() {
					result = .sizeValue(size)
				} else {
					CNLog(logLevel: .error, message: "Failed to convert to Size", atFunction: #function, inFile: #file)
					result = .nullValue
				}
			case .rectType:
				if let rect = self.toRect() {
					result = .rectValue(rect)
				} else {
					CNLog(logLevel: .error, message: "Failed to convert to Rect", atFunction: #function, inFile: #file)
					result = .nullValue
				}
			case .arrayType:
				let srcarr = self.toArray()!
				var dstarr: Array<CNNativeValue> = []
				for elm in srcarr {
					if let object = elementToValue(any: elm) {
						dstarr.append(object)
					} else {
						CNLog(logLevel: .error, message: "Failed to convert to Array", atFunction: #function, inFile: #file)
					}
				}
				result = .arrayValue(dstarr)
			case .dictionaryType:
				var dstdict: Dictionary<String, CNNativeValue> = [:]
				if let srcdict = self.toDictionary() as? Dictionary<String, Any> {
					for (key, value) in srcdict {
						if let obj = elementToValue(any: value) {
							dstdict[key] = obj
						} else {
							CNLog(logLevel: .error, message: "Failed to convert to Dictionary", atFunction: #function, inFile: #file)
						}
					}
				} else {
					CNLog(logLevel: .error, message: "Failed to convert to Dictionary", atFunction: #function, inFile: #file)
				}
				result = CNNativeValue.dictionaryToValue(dictionary: dstdict)
			case .objectType:
				CNLog(logLevel: .error, message: "Failed to convert to Object", atFunction: #function, inFile: #file)
				result = .nullValue
			@unknown default:
				CNLog(logLevel: .error, message: "Unknown case", atFunction: #function, inFile: #file)
				result = .nullValue
			}
		} else {
			result = .nullValue
		}
		return result
	}

	private func elementToValue(any value: Any) -> CNNativeValue? {
		if let val = value as? JSValue {
			return val.toNativeValue()
		} else if let val = value as? KLURL {
			if let url = val.url {
				return CNNativeValue.anyToValue(object: url)
			} else {
				CNLog(logLevel: .error, message: "Null URL", atFunction: #function, inFile: #file)
				return .nullValue
			}
		} else if let val = value as? KLImage {
			if let image = val.coreImage {
				return CNNativeValue.anyToValue(object: image)
			} else {
				CNLog(logLevel: .error, message: "Null Image", atFunction: #function, inFile: #file)
				return .nullValue
			}
		} else {
			return CNNativeValue.anyToValue(object: value)
		}
	}

	public func toText() -> CNText {
		let native = self.toNativeValue()
		return native.toText()
	}
}

