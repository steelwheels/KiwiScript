/**
* @file		KSJsonEncoder.swift
* @brief	Define KSJsonEncoder class
* @par Copyright
*   Copyright (C) 2015 Steel Wheels Project
*/

import Foundation
import JavaScriptCore
import Canary

public class KSJsonEncoder : KSValueVisitor
{
	let textBuffer		= CNTextBuffer()
	var resultString	= ""

	public func encode(value : JSValue) -> CNTextBuffer {
		acceptValue(value)
		flush()
		return textBuffer
	}
	
	private func flush(){
		if resultString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0{
			textBuffer.append(resultString)
			textBuffer.newline()
			resultString = ""
		}
		
	}
	
	public override func visitUndefinedValue(value : JSValue){
		resultString += "undefined"
	}
	
	public override func visitNilValue(value : JSValue){
		resultString += "nil"
	}
	
	public override func visitBooleanValue(value : Bool){
		resultString += "\(value)"
	}
	
	public override func visitNumberObject(number : NSNumber){
		resultString += "\(number)"
	}
	
	public override func visitStringObject(string : NSString){
		resultString += "\(string)"
	}
	
	public override func visitDateObject(date : NSDate){
		resultString += "\(date)"
	}
	
	public override func visitDictionaryObject(dict : NSDictionary){
		resultString += "{"
		flush()
		
		textBuffer.incrementIndent()
		for (key, value) in dict {
			if let keyobj = key as? NSObject {
				acceptObject(keyobj)
			} else {
				fatalError("Unknown key of dictionary: \(key)")
			}

			resultString += " : "
			
			if let valobj = value as? NSObject {
				acceptObject(valobj)
			} else {
				fatalError("Unknown value of dictionary: \(value)")
			}
			
			flush()
		}
		textBuffer.decrementIndent()

		resultString = "}"
		flush()
	}
	
	public override func visitArrayObject(arr : NSArray){
		resultString += "["

		var is1st = true
		textBuffer.incrementIndent()
		for elm in arr {
			if is1st {
				is1st = false
			} else {
				resultString += ", "
			}
			if let elmobj = elm as? NSObject {
				acceptObject(elmobj)
			} else {
				fatalError("Not object: \"\(elm)\"")
			}
		}
		textBuffer.decrementIndent()

		resultString += "]"
	}
	
	public override func visitUnknownObject(obj : NSObject){
		resultString = "unknown"
	}
}


