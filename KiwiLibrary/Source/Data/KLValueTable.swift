/**
 * @file	KLValueTable.swift
 * @brief	Define KLValueTable class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLValueTableProtocol: JSExport
{
	var columnCount:	JSValue { get }
	var rowCount:		JSValue { get }

	func title(_ cidx: JSValue) -> JSValue
	func setTitle(_ cidx: JSValue, _ title: JSValue)
	func value(_ cidx: JSValue, _ ridx: JSValue) -> JSValue
	func setValue(_ cidx: JSValue, _ ridx: JSValue, _ val: JSValue)
}

@objc public class KLValueTable: NSObject, KLValueTableProtocol
{
	private var mTable:	CNNativeValueTable
	private var mContext: 	KEContext

	public init(table tbl: CNNativeValueTable, context ctxt: KEContext){
		mTable   = tbl
		mContext = ctxt
	}

	public var columnCount:	JSValue { get {
		let num = mTable.columnCount
		return JSValue(int32: Int32(num), in: mContext)
	}}

	public var rowCount: JSValue { get {
		let num = mTable.rowCount
		return JSValue(int32: Int32(num), in: mContext)
	}}

	public func title(_ cidx: JSValue) -> JSValue {
		if cidx.isNumber {
			let title = mTable.title(column: Int(cidx.toInt32()))
			return JSValue(object: title, in: mContext)
		}
		return JSValue(nullIn: mContext)
	}

	public func setTitle(_ cidx: JSValue, _ title: JSValue) {
		if cidx.isNumber && title.isString {
			let idx = Int(cidx.toInt32())
			if let str = title.toString() {
				mTable.setTitle(column: idx, title: str)
				return
			}
		}
		NSLog("Failed to set title at \(#function) in \(#file)")
	}

	public func value(_ cidx: JSValue, _ ridx: JSValue) -> JSValue {
		guard ridx.isNumber else {
			return JSValue(nullIn: mContext)
		}
		let rval = Int(ridx.toInt32())
		if cidx.isNumber {
			let cval = Int(cidx.toInt32())
			let ret  = mTable.value(column: cval, row: rval)
			return ret.toJSValue(context: mContext)
		} else if let cval = cidx.toString() {
			let ret  = mTable.value(title: cval, row: rval)
			return ret.toJSValue(context: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	public func setValue(_ cidx: JSValue, _ ridx: JSValue, _ val: JSValue) {
		guard ridx.isNumber else {
			NSLog("INvalid row index at \(#function) in \(#file)")
			return
		}
		let rval = Int(ridx.toInt32())
		if cidx.isNumber {
			let cval = Int(cidx.toInt32())
			let nval = val.toNativeValue()
			mTable.setValue(column: cval, row: rval, value: nval)
		} else if let cval = cidx.toString() {
			let nval = val.toNativeValue()
			mTable.setValue(title: cval, row: rval, value: nval)
		} else {
			NSLog("Invalid column name/index at \(#function) in \(#file)")
		}
	}
}

