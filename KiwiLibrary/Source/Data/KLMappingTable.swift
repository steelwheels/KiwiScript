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
	func setCompareFunction(_ sfunc: JSValue)
}

@objc public class KLMappingTable: KLTable, KLMappingTableProtocol
{
	private var mTable:		CNMappingTable

	public init(mappingTable tbl: CNMappingTable, context ctxt: KEContext) {
		mTable		= tbl
		super.init(table: tbl, context: ctxt)
	}

	public func setFilterFunction(_ ffunc: JSValue) {
		let filter = { (_ rec: CNRecord) -> Bool in
			let recobj = KLRecord(record: rec, context: self.context)
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
		mTable.setFilter(filterFunction: filter)
	}

	public func addVirtualField(_ field: JSValue, _ cbfunc: JSValue) {
		if field.isString {
			if let fname = field.toString() {
				let cbfunc = {
					(_ rec: CNRecord) -> CNValue in
					let recobj = KLRecord(record: rec, context: self.context)
					if let retval = cbfunc.call(withArguments: [recobj]) {
						return retval.toNativeValue()
					} else {
						CNLog(logLevel: .error, message: "Failed to execute callback set by addVirtualField (for field \(fname))")
						return CNValue.null
					}
				}
				mTable.addVirtualField(name: fname, callbackFunction: cbfunc)
				return
			}
		}
		CNLog(logLevel: .error, message: "Invalid \"field\" parameter", atFunction: #function, inFile: #file)
	}

	public var sortOrder: JSValue {
		get {
			return JSValue(int32: Int32(mTable.sortOrder.rawValue), in: self.context)
		}
		set(val) {
			if let num = val.toNumber() {
				if let order = CNSortOrder(rawValue: num.intValue) {
					mTable.sortOrder = order
					return
				}
			}
			CNLog(logLevel: .error, message: "Failed to set invalid sort order parameter", atFunction: #function, inFile: #file)
		}
	}

	public func setCompareFunction(_ compare: JSValue) {
		let cfunc = {
			(_ rec0: CNRecord, _ rec1: CNRecord) -> ComparisonResult in
			if let recobj0 = self.allocateRecord(from: rec0, context: self.context),
			   let recobj1 = self.allocateRecord(from: rec1, context: self.context) {
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
		mTable.setCompareFunction(compareFunc: cfunc)
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

