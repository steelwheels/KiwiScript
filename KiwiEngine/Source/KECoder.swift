/**
 * @file	KECoder.swift
 * @brief	Serialize/Deserialize JSValue
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation
import JavaScriptCore
import Canary

public func KESerializeValue(value v: JSValue) -> CNText?
{
	let serializer = KEValueSerializer()
	serializer.accept(value: v)
	return serializer.result
}

private class KEValueSerializer: KEValueVisitor
{
	public var result: CNText?  = nil

	open override func visit(bool val: Bool){
		result = CNTextLine(string: "\(val)")
	}

	open override func visit(character val: Character){
		result = CNTextLine(string: "\"\(val)\"")
	}

	open override func visit(int val: Int){
		result = CNTextLine(string: "\(val)")
	}

	open override func visit(uInt val: UInt){
		result = CNTextLine(string: "\(val)")
	}

	open override func visit(float val: Float){
		result = CNTextLine(string: "\(val)")
	}

	open override func visit(double	val: Double){
		result = CNTextLine(string: "\(val)")
	}

	open override func visit(string	val: String){
		result = CNTextLine(string: "\"\(val)\"")
	}

	open override func visit(date val: Date){
		let desc = val.description
		result = CNTextLine(string: "\(desc)")
	}

	open override func visit(array val: Array<Any>)
	{
		var elements: Array<CNText> = []
		var isline: Bool = true
		for src in val {
			let dst = encode(any: src)
			elements.append(dst)
			if !isTextLine(text: dst) {
				isline = false
			}
		}
		if isline {
			let newline = CNTextLine(string: "[")
			var is1st   = true
			for src in elements {
				if let src = src as? CNTextLine {
					if is1st {
						is1st = false
					} else {
						newline.append(string: ", ")
					}
					newline.append(text: src)
				}
			}
			newline.append(string: "]")
			result = newline
		} else {
			let newsect = CNTextSection()
			newsect.header = "["
			newsect.footer = "]"
			var is1st   = true
			for src in elements {
				if is1st {
					is1st = false
				} else {
					newsect.append(string: ", ")
				}
				newsect.add(text: src)
			}
			result = newsect
		}
	}

	open override func visit(dictionary val: Dictionary<AnyHashable, Any>)
	{
		var keys   : Array<CNText> = []
		var values : Array<CNText> = []

		var iskeyline = true
		var isdataline = true
		for key in val.keys {
			/* Encode key */
			let keytxt = encode(any: key)
			keys.append(keytxt)
			if !isTextLine(text: keytxt) {
				iskeyline = false
			}
			/* Encode data */
			if let data = val[key] {
				let datatxt = encode(any: data)
				values.append(datatxt)
				if !isTextLine(text: datatxt) {
					isdataline = false
				}
			} else {
				fatalError("Can not happen")
			}
		}
		let keynum = keys.count
		if iskeyline && isdataline {
			let newline = CNTextLine(string: "[")
			var is1st   = true
			for i in 0..<keynum {
				if is1st {
					is1st = false
				} else {
					newline.append(string: ", ")
				}
				let keytxt  = keys[i] as? CNTextLine
				let datatxt = values[i] as? CNTextLine
				newline.append(text: keytxt!)
				newline.append(string: ":")
				newline.append(text: datatxt!)
			}
			result = newline
		} else if iskeyline {
			let newsect = CNTextSection()
			newsect.header = "["
			newsect.footer = "]"
			var is1st = true
			for i in 0..<keynum {
				if is1st {
					is1st = false
				} else {
					newsect.append(string: ", ")
				}
				let keytxt  = keys[i] as? CNTextLine
				let datatxt = values[i]
				newsect.append(text: keytxt!)
				newsect.append(string: ":")
				newsect.add(text: datatxt)
			}
			result = newsect
		} else {
			let newsect = CNTextSection()
			newsect.header = "["
			newsect.footer = "]"
			var is1st = true
			for i in 0..<keynum {
				if is1st {
					is1st = false
				} else {
					newsect.append(string: ", ")
				}
				let keytxt  = keys[i]
				let datatxt = values[i]
				newsect.add(text: keytxt)
				newsect.append(string: ":")
				newsect.add(text: datatxt)
			}
			result = newsect
		}
	}

	open override func visit(any val: Any) {
		let name = String(describing: type(of: val))
		result = CNTextLine(string: "Object<\(name)>")
	}

	open override func visitNull(){
		result = CNTextLine(string: "null")
	}

	open override func visitUndefined(){
		result = CNTextLine(string: "undefined")
	}

	private func encode(any val: Any) -> CNText
	{
		result = nil
		if let jsval = val as? JSValue {
			accept(value: jsval)
		} else {
			accept(any: val)
		}
		if let result = result {
			return result
		} else {
			fatalError("Can not happen (0)")
		}
	}

	private func isTextLine(text src: CNText?) -> Bool {
		if let _ = src as? CNTextLine {
			return true
		} else {
			return false
		}
	}
}
