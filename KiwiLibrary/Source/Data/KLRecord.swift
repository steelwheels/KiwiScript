/**
 * @file	KLRecord.swift
 * @brief	Define KLRecord class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public protocol KLRecordIF: JSExport
{
	var fieldCount:		JSValue { get }
	var fieldNames:		JSValue { get }

	func value(_ name: JSValue) -> JSValue
	func setValue(_ val: JSValue, _ name: JSValue) -> JSValue

	func toString() -> JSValue
}

public protocol KLRecordCore
{
	func core() -> CNRecord
}

@objc public class KLRecord: NSObject, KLRecordIF, KLRecordCore
{
	private static let TEMPORARY_VARIABLE_NAME = "_kiwilibrary_record_temp_var"
	private static var temporary_variable_id   = 0

	private var mRecord:	CNRecord
	private var mContext:	KEContext

	public init(record rcd: CNRecord, context ctxt: KEContext){
		mRecord		= rcd
		mContext	= ctxt
		super.init()
	}

	public static func allocate(record rcd: KLRecord, atFunction atfunc: String, inFile infile: String) -> JSValue {
		let context = rcd.mContext
		guard let rcdval = JSValue(object: rcd, in: context) else {
			CNLog(logLevel: .error, message: "allocate method failed", atFunction: atfunc, inFile: infile)
			return JSValue(nullIn: context)
		}
		let rcdname = temporaryVariableName()
		context.set(name: rcdname, value: rcdval)
		for prop in rcd.core().fieldNames {
			let script =   "Object.defineProperty(\(rcdname), \"\(prop)\", {\n"
				     + "  get()    { return this.value(\"\(prop)\") ;   },\n"
				     + "  set(val) { this.setValue(\"\(prop)\", val) ;  }\n"
				     + "})\n"
			context.evaluateScript(script)
			if context.errorCount != 0 {
				context.resetErrorCount()
				CNLog(logLevel: .error, message: "allocate method failed: \(script)", atFunction: atfunc, inFile: infile)
				return JSValue(nullIn: context)
			}
		}
		return rcdval
	}

	public static func allocate(records rcds: Array<KLRecord>, atFunction atfunc: String, inFile infile: String) -> Array<JSValue> {
		var result: Array<JSValue> = []
		for rcd in rcds {
			result.append(KLRecord.allocate(record: rcd, atFunction: atfunc, inFile: infile))
		}
		return result
	}

	private static func temporaryVariableName() -> String {
		let result = "\(KLRecord.TEMPORARY_VARIABLE_NAME)_\(KLRecord.temporary_variable_id)"
		KLRecord.temporary_variable_id += 1
		return result
	}

	public func core() -> CNRecord {
		return mRecord
	}

	public var fieldCount: JSValue { get {
		return JSValue(int32: Int32(mRecord.fieldCount), in: mContext)
	}}

	public var fieldNames: JSValue { get {
		return JSValue(object: mRecord.fieldNames, in: mContext)
	}}

	public func value(_ name: JSValue) -> JSValue {
		if name.isString {
			if let nstr = name.toString() {
				if let val = mRecord.value(ofField: nstr) {
					return val.toJSValue(context: mContext)
				}
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func setValue(_ val: JSValue, _ name: JSValue) -> JSValue {
		var result = false
		if name.isString {
			if let nstr = name.toString() {
				result = mRecord.setValue(value: val.toNativeValue(), forField: nstr)
			}
		} else {
			CNLog(logLevel: .error, message: "Invalid type of name", atFunction: #function, inFile: #file)
		}
		return JSValue(bool: result, in: mContext)
	}

	public func toString() -> JSValue {
		let val: CNValue = .dictionaryValue(mRecord.toValue())
		return JSValue(object: val.toText().toStrings().joined(separator: "\n"), in: mContext)
	}
}

