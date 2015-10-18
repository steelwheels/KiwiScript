/**
* @file		KSJsonEncoder.swift
* @brief	Define KSJsonEncoder class
* @par Copyright
*   Copyright (C) 2015 Steel Wheels Project
*/

import Foundation
import JavaScriptCore
import Canary

public class KSJsonEncoder : CNJSONEncoder
{
	public func encodeValue(value : JSValue) -> CNTextElement {
		switch value.kind() {
		case .UndefinedValue:
			visitUndefinedValue(value)
		case .NilValue:
			visitNilValue(value) ;
		case .BooleanValue:
			visitBooleanValue(value.toBool()) ;
		case .NumberValue:
			visitNumberObject(value.toNumber()) ;
		case .StringValue:
			visitStringObject(value.toString()) ;
		case .DateValue:
			visitDateObject(value.toDate()) ;
		case .ArrayValue:
			visitArrayObject(value.toArray()) ;
		case .DictionaryValue:
			visitDictionaryObject(value.toDictionary()) ;
		case .ObjectValue:
			if let obj : NSObject = value.toObject() as? NSObject {
				super.encode(obj)
			} else {
				fatalError("Unknown object: \(value)")
			}
		}
		return result() ;
	}
	
	public func visitUndefinedValue(value : JSValue){
		visitStringObject("undefined")
	}
	
	public func visitNilValue(value : JSValue){
		visitStringObject("nil")
	}
	
	public func visitBooleanValue(value : Bool){
		visitStringObject(value ? "true" : "false")
	}
}


