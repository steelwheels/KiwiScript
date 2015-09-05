/**
 * @file		KSValueVisitor.swift
 * @brief	Define KSValueVisitor class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import JavaScriptCore

public class KSValueVisitorInfo : NSObject {
	
}

public class KSValueVisitor : NSObject {
	public func visitUndefinedValue(info : KSValueVisitorInfo){
	}
	public func visitNilValue(info : KSValueVisitorInfo){
	}
	public func visitBooleanValue(value : Bool, info : KSValueVisitorInfo){
	}
	public func visitNumberValue(value : NSNumber, info : KSValueVisitorInfo){
	}
	public func visitStringValue(value : String, info : KSValueVisitorInfo){
	}
	public func visitDateValue(value : NSDate, info : KSValueVisitorInfo){
	}
	public func visitArrayValue(value : NSArray, info : KSValueVisitorInfo){
	}
	public func visitDictionaryValue(value : NSDictionary, info : KSValueVisitorInfo){
	}
	public func visitObjectValue(value : NSObject, info : KSValueVisitorInfo){
	}
	
	public func accept(value : JSValue, visitor : KSValueVisitor, info : KSValueVisitorInfo){
		switch KSValue.kindOfValue(value) {
		case .UndefinedValue:
			visitor.visitUndefinedValue(info)
		case .NilValue:
			visitor.visitNilValue(info) ;
		case .BooleanValue:
			visitor.visitBooleanValue(value.toBool(), info: info) ;
		case .NumberValue:
			visitor.visitNumberValue(value.toNumber(), info: info) ;
		case .StringValue:
			visitor.visitStringValue(value.toString(), info: info) ;
		case .DateValue:
			visitor.visitDateValue(value.toDate(), info: info) ;
		case .ArrayValue:
			visitor.visitArrayValue(value.toArray(), info: info) ;
		case .DictionaryValue:
			visitor.visitDictionaryValue(value.toDictionary(), info: info) ;
		case .ObjectValue:
			if let obj : NSObject = value.toObject() as? NSObject {
				visitor.visitObjectValue(obj, info: info) ;
			} else {
				NSLog("Unknown object: \(value)")
			}
		}
	}
}

