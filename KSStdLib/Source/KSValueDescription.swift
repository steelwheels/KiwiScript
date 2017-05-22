/**
 * @file	KSValueDescription.swift
 * @brief	Define KSValueDescription class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Canary
import JavaScriptCore
import Foundation

public func KSValueDescription(value val: JSValue) -> CNText {
	let converter = KSValueDescriptor()
	return converter.descriptor(of: val)
}

private class KSValueDescriptor: KSValueVisitor
{
	private var mCurrentText:CNText = CNTextLine(string: "")

	public func descriptor(of value: JSValue) -> CNText {
		acceptValue(value: value)
		return mCurrentText
	}

	public override func visit(undefinedValue value : JSValue){
		mCurrentText = CNTextLine(string: "undefined")
	}

	public override func visit(nilValue value : JSValue){
		mCurrentText = CNTextLine(string: "nil")
	}

	public override func visit(booleanValue value : Bool){
		let str: String
		if value {
			str = "true"
		} else {
			str = "false"
		}
		mCurrentText = CNTextLine(string: str)
	}

	public override func visit(number n: NSNumber) {
		mCurrentText = CNTextLine(string: n.stringValue)
	}

	public override func visit(string s: String) {
		mCurrentText = CNTextLine(string: s)
	}

	public override func visit(date d: Date) {
		mCurrentText = CNTextLine(string: d.description)
	}

	public override func visit(dictionary d: [String:AnyObject])
	{
		let section = CNTextSection()
		section.header = "["
		section.footer = "]"
		var is1st      = true
		for (key, valobj) in d {
			if is1st {
				is1st  = false
			} else {
				section.append(string: ",")
			}
			acceptObject(object: valobj)
			addElement(section: section, line: "\(key):", element: mCurrentText)
		}
		mCurrentText = section
	}

	public override func visit(array a: [AnyObject])
	{
		let section = CNTextSection()
		section.header = "["
		section.footer = "]"
		var is1st      = true
		for valobj in a {
			if is1st {
				is1st  = false
			} else {
				mCurrentText.append(string: ", ")
			}
			acceptObject(object: valobj)
			addElement(section: section, line: "", element: mCurrentText)
		}
		mCurrentText = section
	}

	private func addElement(section sect: CNTextSection, line ln: String, element txt: CNText){
		if let sline = txt as? CNTextLine {
			sect.append(string: ln + sline.string)
		} else if let ssect = txt as? CNTextSection {
			if ln.lengthOfBytes(using: .utf8) > 0 {
				sect.append(string: ln)
			}
			sect.add(text: ssect)
		} else {
			fatalError("Unknown object")
		}
	}

	public override func visit(object o: AnyObject)
	{
		mCurrentText = CNTextLine(string: "AnyObject")
	}
}

