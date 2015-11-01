/**
* @file		KSValueSerializer.swift
* @brief	Define KSValueSerializer class
* @par Copyright
*   Copyright (C) 2015 Steel Wheels Project
*/

import Foundation
import JavaScriptCore
import Canary

public class KSValueSerializer
{
	var resultString : String
	var serializer   : CNObjectSerializer
	
	public init() {
		resultString = ""
		serializer = CNObjectSerializer()
	}
	
	public func serializeValue(value : JSValue) -> String {
		resultString = ""
		switch value.kind() {
		case .UndefinedValue:
			visitUndefinedValue(value)
		case .NilValue:
			visitNilValue(value) ;
		case .BooleanValue:
			visitBooleanValue(value.toBool()) ;
		case .NumberValue:
			resultString = serializer.serializeObject(value.toNumber())
		case .StringValue:
			resultString = serializer.serializeObject(value.toString())
		case .DateValue:
			resultString = serializer.serializeObject(value.toDate())
		case .ArrayValue:
			resultString = serializer.serializeObject(value.toArray())
		case .DictionaryValue:
			resultString = serializer.serializeObject(value.toDictionary())
		case .ObjectValue:
			if let obj = value.toObject() as? NSObject {
				resultString = serializer.serializeObject(obj)
			} else {
				let typename = CNTypeName(value.toObject())
				resultString = "<unknown-type: \(typename)>"
			}
		}
		return resultString
	}

	public func visitUndefinedValue(value : JSValue){
		resultString = "<undefined>"
	}
	public func visitNilValue(value : JSValue){
		resultString = "<nil>"
	}
	public func visitBooleanValue(value : Bool){
		if value {
			resultString = "true"
		} else {
			resultString = "false"
		}
	}
}


