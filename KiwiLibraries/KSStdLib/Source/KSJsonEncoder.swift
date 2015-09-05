/**
* @file		KSJsonEncoder.swift
* @brief	Define KSJsonEncoder class
* @par Copyright
*   Copyright (C) 2015 Steel Wheels Project
*/

import Foundation
import JavaScriptCore
import Canary

public class KSJsonEncoderInfo : KSValueVisitorInfo {
	public var resultString = ""
}

public class KSJsonEncoder : KSValueVisitor
{
	let textBuffer		= CNTextBuffer()
	var resultString	= ""

	public func encode(value : JSValue) -> CNTextBuffer {
		let info = KSJsonEncoderInfo()
		accept(value, visitor:self, info: info)
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
	
	public override func visitUndefinedValue(info : KSValueVisitorInfo){
		resultString += "undefined"
	}
	
	public override func visitNilValue(info : KSValueVisitorInfo){
		resultString += "nil"
	}
	
	public override func visitBooleanValue(value : Bool, info : KSValueVisitorInfo){
		resultString += "\(value)"
	}
	
	public override func visitNumberValue(value : NSNumber, info : KSValueVisitorInfo){
		resultString += "\(value)"
	}
	
	public override func visitStringValue(value : String, info : KSValueVisitorInfo) {
		resultString += "\"\(value)\""
	}
	
	public override func visitDateValue(value : NSDate, info : KSValueVisitorInfo){
		resultString += "\(value)"
	}
	
	public override func visitArrayValue(value : NSArray, info : KSValueVisitorInfo){
		var arraystr = "["
		var is1st = true
		for elm in value {
			if let elmval = elm as? JSValue {
				if is1st {
					is1st = false
				} else {
					arraystr += resultString + ", "
				}
				accept(elmval, visitor:self, info: info)
			} else {
				fatalError("JSValue expected")
			}
		}
		resultString = arraystr + "]"
	}
	
	public override func visitDictionaryValue(value : NSDictionary, info : KSValueVisitorInfo){
		resultString = resultString + " {"
		flush()
		
		textBuffer.incrementIndent()
		for (key, data) in value {
			var membstr = ""
			if let keyval = key as? JSValue {
				membstr += keyval.description
			} else {
				fatalError("JSValue expected")
			}
			membstr += ":"
			if let dataval = data as? JSValue {
				membstr += dataval.description
			} else {
				fatalError("JSValue expected")
			}
			textBuffer.append(membstr)
			textBuffer.newline()
		}
		textBuffer.decrementIndent()
		
		resultString = "}"
	}
}


