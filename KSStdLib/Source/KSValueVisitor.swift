/**
 * @file		KSValueVisitor.swift
 * @brief	Define KSValueVisitor class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import JavaScriptCore
import Canary

public class KSValueVisitor : CNObjectVisitor {
	public func acceptValue(value : JSValue){
		switch value.kind {
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
				visitUnknownObject(obj) ;
			} else {
				fatalError("Unknown object: \(value)")
			}
		}
	}
	
	public func visitUndefinedValue(value : JSValue){		}
	public func visitNilValue(value : JSValue){			}
	public func visitBooleanValue(value : Bool){			}
}


