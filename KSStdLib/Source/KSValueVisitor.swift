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
			visit(undefinedValue: value)
		case .NilValue:
			visit(nilValue: value) ;
		case .BooleanValue:
			visit(booleanValue: value.toBool()) ;
		case .NumberValue:
			visit(number: value.toNumber()) ;
		case .StringValue:
			visit(string: value.toString()) ;
		case .DateValue:
			visit(date: value.toDate()) ;
		case .ArrayValue:
			visit(array: value.toArray() as [AnyObject]) ;
		case .DictionaryValue:
			if let dict0 = value.toDictionary() {
				var newdict:[String:AnyObject] = [:]
				for (key, value) in dict0 {
					if let keystr = key as? String {
						let valobj = value as AnyObject
						newdict[keystr] = valobj
					} else {
						fatalError("Not string key")
					}
				}
				visit(dictionary: newdict)
			}
		case .ObjectValue:
			if let obj : NSObject = value.toObject() as? NSObject {
				visit(object: obj) ;
			} else {
				fatalError("Unknown object: \(value)")
			}
		}
	}
	
	public func visit(undefinedValue value : JSValue){		}
	public func visit(nilValue value : JSValue){			}
	public func visit(booleanValue value : Bool){			}
}


