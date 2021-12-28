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

	public var isDictionary: Bool {
		get {
			if self.isObject {
				if let _ = self.toObject() as? Dictionary<String, Any> {
					return true
				}
			}
			return false
		}
	}

	public var isPoint: Bool {
		get { return CGPoint.fromJSValue(scriptValue: self) != nil }
	}

	/* There is built-in method
	public func toPoint() -> CGPoint? {
		return CGPoint(scriptValue: self)
	}*/

	public var isSize: Bool {
		get { return CGSize.fromJSValue(scriptValue: self) != nil }
	}

	/* There is built-in method
	public func toSize() -> CGSize? {
		return CGSize(scriptValue: self)
	}*/

	public var isRect: Bool {
		get { return CGRect.fromJSValue(scriptValue: self) != nil }
	}

	/* There is built-in method
	public func toRect() -> CGRect? {
		return CGRect(scriptValue: self)
	}*/

	public var isRange: Bool {
		get { return NSRange.fromJSValue(scriptValue: self) != nil }
	}

	/* There is built-in method
	public func toRange() -> NSRange? {
		return NSRange(scriptValue: self)
	}*/

	public var isEnum: Bool {
		get { return CNEnum.fromJSValue(scriptValue: self) != nil }
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

	public func toImage() -> CNImage? {
		if let imgobj = self.toObject() as? KLImage {
			if let img = imgobj.coreImage {
				return img
			}
		}
		return nil
	}

	public func toColor() -> CNColor? {
		if let colobj = self.toObject() as? KLColor {
			return colobj.core
		}
		return nil
	}

	public var isReference: Bool {
		get { return CNValueReference.fromJSValue(scriptValue: self) != nil }
	}

	public func toReference() -> CNValueReference? {
		return CNValueReference.fromJSValue(scriptValue: self)
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

	public var type: CNValueType? {
		get {
			var result: CNValueType?
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
			} else if self.isDictionary {
				result = .dictionaryType
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
			} else if self.isReference {
				result = .referenceType
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

	public func toNativeValue() -> CNValue {
		let result: CNValue
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
				if let url = self.toURL() {
					result = .URLValue(url)
				} else {
					result = .nullValue
				}
			case .imageType:
				if let img = self.toImage() {
					result = .imageValue(img)
				} else {
					result = .nullValue
				}
			case .colorType:
				if let col = self.toColor() {
					result = .colorValue(col)
				} else {
					result = .nullValue
				}
			case .enumType:
				if let eval = self.toEnum() {
					result = CNValue.enumValue(eval)
				} else {
					result = .nullValue
				}
			case .rangeType:
				result = .rangeValue(self.toRange())
			case .pointType:
				result = .pointValue(self.toPoint())
			case .sizeType:
				result = .sizeValue(self.toSize())
			case .rectType:
				result = .rectValue(self.toRect())
			case .arrayType:
				let srcarr = self.toArray()!
				var dstarr: Array<CNValue> = []
				for elm in srcarr {
					if let object = elementToValue(any: elm) {
						dstarr.append(object)
					} else {
						CNLog(logLevel: .error, message: "Failed to convert to Array", atFunction: #function, inFile: #file)
					}
				}
				result = .arrayValue(dstarr)
			case .dictionaryType:
				var dstdict: Dictionary<String, CNValue> = [:]
				if let srcdict = self.toDictionary() as? Dictionary<String, Any> {
					for (key, value) in srcdict {
						if let obj = elementToValue(any: value) {
							dstdict[key] = obj
						} else {
							CNLog(logLevel: .error, message: "Failed to convert to Dictionary: key=\(key), value=\(value)", atFunction: #function, inFile: #file)
						}
					}
				} else {
					CNLog(logLevel: .error, message: "Failed to convert to Dictionary: \(String(describing: self.toDictionary()))", atFunction: #function, inFile: #file)
				}
				if let scalar = CNValue.dictionaryToValue(dictionary: dstdict) {
					result = scalar
				} else {
					result = .dictionaryValue(dstdict)
				}
			case .objectType:
				CNLog(logLevel: .error, message: "Failed to convert to Object", atFunction: #function, inFile: #file)
				result = .nullValue
			case .referenceType:
				if let refval = self.toReference() {
					result = .reference(refval)
				} else {
					result = .nullValue
				}
			@unknown default:
				CNLog(logLevel: .error, message: "Unknown case", atFunction: #function, inFile: #file)
				result = .nullValue
			}
		} else {
			result = .nullValue
		}
		return result
	}

	private func elementToValue(any value: Any) -> CNValue? {
		if let val = value as? JSValue {
			return val.toNativeValue()
		} else if let val = value as? KLURL {
			if let url = val.url {
				return CNValue.anyToValue(object: url)
			} else {
				CNLog(logLevel: .error, message: "Null URL", atFunction: #function, inFile: #file)
				return .nullValue
			}
		} else if let val = value as? KLImage {
			if let image = val.coreImage {
				return CNValue.anyToValue(object: image)
			} else {
				CNLog(logLevel: .error, message: "Null Image", atFunction: #function, inFile: #file)
				return .nullValue
			}
		} else {
			return CNValue.anyToValue(object: value)
		}
	}

	public func toText() -> CNText {
		let native = self.toNativeValue()
		return native.toText()
	}
}

