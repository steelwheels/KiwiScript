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

@objc public protocol KLValueColumnProtocol: JSExport
{
	var title: JSValue	{ get set }
	var count: JSValue 	{ get }

	func value(_ idx: JSValue) -> JSValue
	func forEach(_ cbfunc: JSValue)
	func setValue(_ idx: JSValue, _ val: JSValue)
	func appendValue(_ val: JSValue)
}

@objc public protocol KLValueTableProtocol: JSExport
{
	var columnCount: JSValue	{ get }
	var rowCount: JSValue		{ get }

	func column(_ idx: JSValue) -> JSValue
	func forEach(_ cbfunc: JSValue)
	func setColumn(_ idx: JSValue, _ col: JSValue)
	func appendColumn(_ col: JSValue)
}

@objc public class KLValueColumn: NSObject, KLValueColumnProtocol
{
	private var mNativeColumn:	CNNativeValueColumn
	private var mContext:		KEContext

	public init(nativeColumn colmun: CNNativeValueColumn, context ctxt: KEContext){
		mNativeColumn	= colmun
		mContext	= ctxt
	}

	public var nativeObject: CNNativeValueColumn { get { return mNativeColumn }}

	public var title: JSValue {
		get {
			if let titlestr = mNativeColumn.title {
				return JSValue(object: titlestr, in: mContext)
			} else {
				return JSValue(nullIn: mContext)
			}
		}
		set(val){
			if val.isString {
				mNativeColumn.title = val.toString()
			} else {
				mNativeColumn.title = nil
			}
		}
	}

	public var count: JSValue {
		get { return JSValue(int32: Int32(mNativeColumn.count), in: mContext) }
	}

	public func value(_ idx: JSValue) -> JSValue {
		if let val = value(at: idx) {
			return val.toJSValue(context: mContext)
		} else {
			return JSValue(undefinedIn: mContext)
		}
	}

	public func forEach(_ cbfunc: JSValue){
		mNativeColumn.forEach({
			(_ val: CNNativeValue) -> Void in
			let _ = cbfunc.call(withArguments: [val.toJSValue(context: mContext)])
		})
	}

	public func setValue(_ idx: JSValue, _ val: JSValue){
		if idx.isNumber {
			let nidx = Int(idx.toInt32())
			let nval = val.toNativeValue()
			mNativeColumn.setValue(index: nidx, value: nval)
		} else {
			NSLog("Invalid index at \(#function)")
		}
	}

	public func appendValue(_ val: JSValue){
		let nval = val.toNativeValue()
		mNativeColumn.appendValue(value: nval)
	}

	private func value(at idx: JSValue) -> CNNativeValue? {
		if idx.isNumber {
			if let num = idx.toNumber() {
				if let val = mNativeColumn.value(index: Int(num.int32Value)) {
					return val
				}
			}
		}
		NSLog("Invalid index at \(#function)")
		return nil
	}
}

@objc public class KLValueTable: NSObject, KLValueTableProtocol
{
	private var mNativeTable:	CNNativeValueTable
	private var mContext:		KEContext

	public init(nativeTable table: CNNativeValueTable, context ctxt: KEContext){
		mNativeTable	= table
		mContext	= ctxt
	}

	public var columnCount: JSValue	{
		get { return JSValue(int32: Int32(mNativeTable.columnCount), in: mContext) }
	}

	public var rowCount: JSValue {
		get { return JSValue(int32: Int32(mNativeTable.rowCount), in: mContext) }
	}

	public func column(_ idx: JSValue) -> JSValue {
		if let nidx = idx.toNumber() {
			if let ncol = mNativeTable.column(index: nidx.intValue) {
				let colobj = KLValueColumn(nativeColumn: ncol, context: mContext)
				return JSValue(object: colobj, in: mContext)
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func forEach(_ cbfunc: JSValue){
		mNativeTable.forEach({
			(_ val: CNNativeValueColumn) -> Void in
			let obj = KLValueColumn(nativeColumn: val, context: mContext)
			let _   = cbfunc.call(withArguments: [obj])
		})
	}

	public func setColumn(_ idx: JSValue, _ col: JSValue){
		if let nidx = idx.toNumber(), let colobj = col.toObject() as? KLValueColumn {
			mNativeTable.setColumn(index: nidx.intValue, column: colobj.nativeObject)
		} else {
			NSLog("Invalid index at \(#file)")
		}
	}

	public func appendColumn(_ col: JSValue){
		if let colobj = col.toObject() as? KLValueColumn {
			mNativeTable.appendColumn(column: colobj.nativeObject)
		} else {
			NSLog("Invalid index at \(#file)")
		}
	}
}

