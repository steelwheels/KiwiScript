/**
* @file		KSValue.swift
* @brief	Prepare utility functions for JSValue
* @par Copyright
*   Copyright (C) 2015 Steel Wheels Project
*/

import Foundation
import JavaScriptCore
import Canary

public enum KSValueKind {
	case UndefinedValue
	case NilValue
	case BooleanValue
	case NumberValue
	case StringValue
	case DateValue
	case ArrayValue
	case DictionaryValue
	case ObjectValue
	
	func toString() -> String {
		var result = "?"
		switch self {
		case .UndefinedValue:
			result = "Undefined"
		case .NilValue:
			result = "Nil"
		case .BooleanValue:
			result = "Boolean"
		case .NumberValue:
			result = "Number"
		case .StringValue:
			result = "String"
		case .DateValue:
			result = "Date"
		case .ArrayValue:
			result = "Array"
		case .DictionaryValue:
			result = "Dictionary"
		case .ObjectValue:
			result = "Object"
		}
		return result ;
	}
}

public class KSValue : NSObject
{
	public class func kindOfValue(value : JSValue) -> KSValueKind {
		var result = KSValueKind.UndefinedValue
		if value.isUndefined {
			result = KSValueKind.UndefinedValue
		} else if value.isNull {
			result = KSValueKind.NilValue
		} else if value.isBoolean {
			result = KSValueKind.BooleanValue
		} else if value.isNumber {
			result = KSValueKind.NumberValue
		} else if value.isString {
			result = KSValueKind.StringValue
		} else if value.isObject {
			if let _ = value.toObjectOfClass(NSDictionary) {
				result = KSValueKind.DictionaryValue
			} else if let _ = value.toObjectOfClass(NSArray){
				result = KSValueKind.ArrayValue
			} else if let _ = value.toObjectOfClass(NSDate){
				result = KSValueKind.DateValue
			} else {
				result = KSValueKind.ObjectValue
			}
		}
		return result
	}
	
	public class func isScalar(value : JSValue) -> Bool {
		var result = true
		switch kindOfValue(value){
		case .UndefinedValue:	result = true ;
		case .NilValue:		result = true ;
		case .BooleanValue:	result = true ;
		case .NumberValue:	result = true ;
		case .StringValue:	result = true ;
		case .DateValue:	result = true ;
		case .ArrayValue:	result = false ;
		case .DictionaryValue:	result = false ;
		case .ObjectValue:	result = false ;
		}
		return result 
	}
}


