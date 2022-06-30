/**
 * @file	KLMappingTable.swift
 * @brief	Define KLMappingTable class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public protocol KLMappingTableProtocol: JSExport
{
	// FilterFunction = (_ rec: KLRecord) -> Bool
	func setFilterFunction(_ ffunc: JSValue)

	// addVirtualField(_ field: String, callbackFunction cbfunc: @escaping VirtualFieldCallback)
	// VirtualFieldCallback = (_ rec: CNRecord) -> CNValue	// (field-name, row-index) -> Value
	func addVirtualField(_ field: JSValue, _ cbfunc: JSValue)

	// var sortOrder: CNSortOrder?
	var sortOrder: JSValue { set get }

	// CompareFunction = (_ rec0: KLRecord, _ rec1: KLRecord) -> ComparisonResult
	func setCompareFunction(_ comp: JSValue)
}

extension CNMappingTable
{
	public func setFilterFunction(scriptFunc ffunc: JSValue, context ctxt: KEContext) {
		let filter = { (_ rec: CNRecord) -> Bool in
			let recobj = KLRecord(record: rec, context: ctxt)
			var retval = false
			if let retobj = ffunc.call(withArguments: [recobj]) {
				if retobj.isBoolean {
					retval = retobj.toBool()
				} else {
					CNLog(logLevel: .error, message: "Invalid return value from \"setFilter\" function")
				}
			} else {
				CNLog(logLevel: .error, message: "Failed to execute \"setFiler\" function")
			}
			return retval
		}
		self.setFilter(filterFunction: filter)
	}

	public func addVirtualField(scriptField field: JSValue, scriptCallbackFunc cbfunc: JSValue, context ctxt: KEContext) {
		if field.isString {
			if let fname = field.toString() {
				let cbfunc = {
					(_ rec: CNRecord) -> CNValue in
					let recobj = KLRecord(record: rec, context: ctxt)
					if let retval = cbfunc.call(withArguments: [recobj]) {
						return retval.toNativeValue()
					} else {
						CNLog(logLevel: .error, message: "Failed to execute callback set by addVirtualField (for field \(fname))")
						return .nullValue
					}
				}
				self.addVirtualField(name: fname, callbackFunction: cbfunc)
				return
			}
		}
		CNLog(logLevel: .error, message: "Invalid \"field\" parameter", atFunction: #function, inFile: #file)
	}

	public func setSortOrder(scriptValue val: JSValue) {
		if val.isNumber {
			if let num = val.toNumber() {
				if let newval = CNSortOrder(rawValue: num.intValue) {
					self.sortOrder = newval
					return
				}
			}
		} else if val.isNull {
			self.sortOrder = nil
			return
		}
		CNLog(logLevel: .error, message: "Unexpected parameter to set sortOrder property: \(val.description)")
	}

	public func getSortOrder(context ctxt: KEContext) -> JSValue {
		if let order = self.sortOrder {
			return JSValue(int32: Int32(order.rawValue), in: ctxt)
		} else {
			return JSValue(nullIn: ctxt)
		}
	}

	public func setCompareFunction(scriptFunc compare: JSValue, context ctxt: KEContext) {
		let compfunc = {
			(_ rec0: CNRecord, _ rec1: CNRecord) -> ComparisonResult in
			if let recobj0 = self.allocateRecord(from: rec0, context: ctxt),
			   let recobj1 = self.allocateRecord(from: rec1, context: ctxt) {
				if let resobj  = compare.call(withArguments: [recobj0, recobj1]) {
					if let compres = self.valueToComparisonResult(value: resobj) {
						return compres
					} else {
						CNLog(logLevel: .error, message: "Unexpected return value from callback for SetSortMethod: \(resobj)")
					}
				} else {
					CNLog(logLevel: .error, message: "Failed to execute callback for setSortMethod", atFunction: #function, inFile: #file)
				}
			} else {
				CNLog(logLevel: .error, message: "Failed to call callback for setSortMethod", atFunction: #function, inFile: #file)
			}
			return .orderedSame
		}
		self.set(compareFunction: compfunc)
	}

	private func valueToComparisonResult(value val: JSValue) -> ComparisonResult? {
		if val.isNumber {
			if let num = val.toNumber() {
				return ComparisonResult(rawValue: num.intValue)
			}
		}
		return nil
	}

	private func allocateRecord(from rec: CNRecord, context ctxt: KEContext) -> JSValue? {
		let recobj = KLRecord(record: rec, context: ctxt)
		return KLRecord.allocate(record: recobj)
	}
}

@objc public class KLMappingTable: KLTable, KLMappingTableProtocol
{
	private var mTable:		CNMappingTable

	public init(mappingTable tbl: CNMappingTable, context ctxt: KEContext) {
		mTable	= tbl
		super.init(table: tbl, context: ctxt)
	}

	public func setFilterFunction(_ ffunc: JSValue) {
		mTable.setFilterFunction(scriptFunc: ffunc, context: self.context)
	}

	public func addVirtualField(_ field: JSValue, _ cbfunc: JSValue) {
		mTable.addVirtualField(scriptField: field, scriptCallbackFunc: cbfunc, context: self.context)
	}

	public var sortOrder: JSValue {
		get      { return mTable.getSortOrder(context: self.context) }
		set(val) { mTable.setSortOrder(scriptValue: val) }
	}

	public func setCompareFunction(_ compare: JSValue) {
		mTable.setCompareFunction(scriptFunc: compare, context: self.context)
	}
}

