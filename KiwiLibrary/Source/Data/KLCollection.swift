/**
 * @file	KLCollection.swift
 * @brief	Define KLCollection class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public protocol KLCollectionProtocol: JSExport
{
	var sectionCount: JSValue 	{ get }
	func itemCount(_ sec: JSValue) -> JSValue

	func header(_ sec: JSValue) -> JSValue
	func footer(_ sec: JSValue) -> JSValue
	func value(_ sec: JSValue, _ item: JSValue) -> JSValue
	func add(_ hdr: JSValue, _ ftr: JSValue, _ items: JSValue)

	func toStrings() -> JSValue
}

@objc public class KLCollection: NSObject, KLCollectionProtocol
{
	private var mCollection:	CNCollection
	private var mContext:		KEContext

	public var core: CNCollection { get { return mCollection }}

	public init(collection col: CNCollection, context ctxt: KEContext){
		mCollection	= col
		mContext	= ctxt
	}

	public var sectionCount: JSValue { get {
		return JSValue(int32: Int32(mCollection.sectionCount), in: mContext)
	}}

	public func itemCount(_ sec: JSValue) -> JSValue {
		if let secno = sectionNumber(sec) {
			return JSValue(int32: Int32(mCollection.itemCount(inSection: secno)), in: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	public func header(_ sec: JSValue) -> JSValue {
		if let secno = sectionNumber(sec) {
			let hdr: String = mCollection.header(ofSection: secno)
			return JSValue(object: hdr, in: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	public func footer(_ sec: JSValue) -> JSValue {
		if let secno = sectionNumber(sec) {
			let ftr: String = mCollection.footer(ofSection: secno)
			return JSValue(object: ftr, in: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	public func value(_ sec: JSValue, _ item: JSValue) -> JSValue {
		if let (secno, itemno) = itemNumber(sec, item) {
			if let sym = mCollection.value(section: secno, item: itemno) {
				return JSValue(object: sym.name, in: mContext)
			} else {
				CNLog(logLevel: .error, message: "Invalid section/item number", atFunction: #function, inFile: #file)
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func add(_ hdr: JSValue, _ ftr: JSValue, _ items: JSValue){
		if let hdrstr = hdr.toString(), let ftrstr = ftr.toString() {
			if let params = convertItems(items) {
				mCollection.add(header: hdrstr, footer: ftrstr, items: params)
			}
		}
	}

	public func toStrings() -> JSValue {
		let strs = mCollection.toText().toStrings()
		return JSValue(object: strs, in: mContext)
	}

	private func convertItems(_ items: JSValue) -> Array<CNSymbol>? {
		guard items.isArray else {
			return nil
		}
		if let arr = items.toArray() {
			var result: Array<CNSymbol> = []
			arr.forEach({
				(_ elm: Any) in
				if let item = convertItem(elm) {
					result.append(item)
				}
			})
			return result
		}
		return nil
	}

	private func convertItem(_ item: Any) -> CNSymbol? {
		if let val = item as? JSValue {
			if val.isString {
				if let str = val.toString() {
					return convertItem(name: str)
				}
			} else if val.isNull {
				return nil
			}
		} else if let str = item as? String {
			return convertItem(name: str)
		}
		CNLog(logLevel: .error, message: "Unsupoorted object: \(item)", atFunction: #function, inFile: #file)
		return nil
	}

	private func convertItem(name nm: String) -> CNSymbol? {
		if let sym = CNSymbol.decode(fromName: nm) {
			return sym
		} else {
			CNLog(logLevel: .error, message: "Unknown symbol name: \(nm)")
			return nil
		}
	}

	private func sectionNumber(_ sec: JSValue) -> Int? {
		if sec.isNumber {
			let secno = Int(sec.toInt32())
			if 0<=secno && secno<mCollection.sectionCount {
				return secno
			}
		}
		return nil
	}

	private func itemNumber(_ sec: JSValue, _ item: JSValue) -> (Int, Int)? {
		if sec.isNumber && item.isNumber {
			let secno   = Int(sec.toInt32())
			if 0<=secno && secno<mCollection.sectionCount {
				let itemno  = Int(item.toInt32())
				let itemcnt = mCollection.itemCount(inSection: secno)
				if 0<=itemno && itemno<itemcnt {
					return (secno, itemno)
				}
			}
		}
		return nil
	}
}


