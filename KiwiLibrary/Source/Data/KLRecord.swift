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

	public static func allocate(record rcd: KLRecord) -> JSValue? {
		let context = rcd.mContext
		guard let rcdval = JSValue(object: rcd, in: context) else {
			CNLog(logLevel: .error, message: "allocate object failed", atFunction: #function, inFile: #file)
			return nil
		}
		let rcdname = temporaryVariableName()
		context.set(name: rcdname, value: rcdval)
		for prop in rcd.core().fieldNames {
			let script =   "Object.defineProperty(\(rcdname), \"\(prop)\", {\n"
				     + "  get()    { return this.value(\"\(prop)\") ;   },\n"
				     + "  set(val) { this.setValue(val, \"\(prop)\") ;  }\n"
				     + "}) ;\n"
			context.evaluateScript(script)
			if context.errorCount != 0 {
				context.resetErrorCount()
				CNLog(logLevel: .error, message: "execute method failed: \(script)", atFunction: #function, inFile: #file)
				return nil
			}
		}
		return rcdval
	}

	public static func allocate(records rcds: Array<KLRecord>, context ctxt: KEContext) -> JSValue? {
		guard let result = JSValue(newArrayIn: ctxt) else {
			CNLog(logLevel: .error, message: "Failed to allocate array", atFunction: #function, inFile: #file)
			return nil
		}
		let resname = temporaryVariableName()
		ctxt.set(name: resname, value: result)
		for rec in rcds {
			if let elmval = allocate(record: rec) {
				let elmname = temporaryVariableName()
				ctxt.set(name: elmname, value: elmval)
				let script = "\(resname).push(\(elmname)) ;\n"
				ctxt.evaluateScript(script)
				if ctxt.errorCount != 0 {
					ctxt.resetErrorCount()
					CNLog(logLevel: .error, message: "push method failed: \(script)", atFunction: #function, inFile: #file)
					return JSValue(nullIn: ctxt)
				}
			} else {
				CNLog(logLevel: .error, message: "Failed to allocation", atFunction: #function, inFile: #file)
				return nil
			}
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

