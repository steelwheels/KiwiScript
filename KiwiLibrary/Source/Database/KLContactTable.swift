/**
 * @file	KLContactTable.swift
 * @brief	Define KLContactTable class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutDatabase
import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLContactTableLoaderProtocol: JSExport
{
	func load(_ cbfunc: JSValue) -> JSValue
}

@objc public class KLContactTable: NSObject, KLValueTableProtocol, KLContactTableLoaderProtocol
{
	private var mContactTable:	CNContactTable
	private var mContext:		KEContext

	public init(contactTable ctable: CNContactTable, context ctxt: KEContext){
		mContactTable	= ctable
		mContext	= ctxt
	}

	public var core: CNNativeTableInterface {
		get { return mContactTable }
	}

	public func load(_ cbfunc: JSValue) -> JSValue {
		mContactTable.load(callback: {
			(_ granted: Bool) -> Void in
			if !cbfunc.isNull {
				if let result = JSValue(bool: granted, in: self.mContext) {
					cbfunc.call(withArguments: [result])
				}
			}
		})
		return JSValue(bool: true, in: mContext)
	}

	public var columnCount: JSValue { get {
		return JSValue(int32: Int32(mContactTable.columnCount), in: mContext)
	}}

	public var rowCount: JSValue { get {
		return JSValue(int32: Int32(mContactTable.rowCount), in: mContext)
	}}

	public func title(_ cidx: JSValue) -> JSValue {
		if let cnum = valueToInt(value: cidx){
			let str = mContactTable.title(column: cnum)
			return JSValue(object: str, in: mContext)
		}
		return JSValue(nullIn: mContext)
	}

	public func setTitle(_ cidx: JSValue, _ title: JSValue) {
		if let cnum = valueToInt(value: cidx), let tstr = valueToString(value: title) {
			mContactTable.setTitle(column: cnum, title: tstr)
		} else {
			CNLog(logLevel: .error, message: "Invalid paramere", atFunction: #function, inFile: #file)
		}
	}

	public func value(_ cidx: JSValue, _ ridx: JSValue) -> JSValue {
		if let cnum = valueToColumnIndex(value: cidx), let rnum = valueToInt(value: ridx) {
			let retval = mContactTable.value(columnIndex: cnum, row: rnum)
			return retval.toJSValue(context: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	public func setValue(_ cidx: JSValue, _ ridx: JSValue, _ val: JSValue) {
		if let cnum = valueToColumnIndex(value: cidx), let rnum = valueToInt(value: ridx) {
			let nval = val.toNativeValue()
			mContactTable.setValue(columnIndex: cnum, row: rnum, value: nval)
		}
	}

	private func valueToInt(value val: JSValue) -> Int? {
		if val.isNumber {
			return Int(val.toInt32())
		} else {
			return nil
		}
	}

	private func valueToString(value val: JSValue) -> String? {
		if val.isString {
			return val.toString()
		} else {
			return nil
		}
	}

	private func valueToColumnIndex(value val: JSValue) -> CNColumnIndex? {
		if let num = valueToInt(value: val) {
			return .number(num)
		} else if let str = valueToString(value: val) {
			return .title(str)
		} else {
			return nil
		}
	}
}

