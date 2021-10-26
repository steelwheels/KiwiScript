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
			let hdr = mCollection.header(ofSection: secno)
			return JSValue(object: hdr, in: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	public func footer(_ sec: JSValue) -> JSValue {
		if let secno = sectionNumber(sec) {
			let ftr = mCollection.footer(ofSection: secno)
			return JSValue(object: ftr, in: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	public func value(_ sec: JSValue, _ item: JSValue) -> JSValue {
		if let (secno, itemno) = itemNumber(sec, item) {
			if let val = mCollection.value(section: secno, item: itemno) {
				let result: JSValue
				switch val {
				case .image(let url):
					let urlobj = KLURL(URL: url, context: mContext)
					result = JSValue(object: urlobj, in: mContext)
				@unknown default:
					CNLog(logLevel: .error, message: "Can not happen", atFunction: #function, inFile: #file)
					result = JSValue(nullIn: mContext)
				}
				return result
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

	private func convertItems(_ items: JSValue) -> Array<CNCollection.Item>? {
		guard items.isArray else {
			return nil
		}
		if let arr = items.toArray() {
			var result: Array<CNCollection.Item> = []
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

	private func convertItem(_ item: Any) -> CNCollection.Item? {
		if let val = item as? JSValue {
			if let obj = val.toObject() {
				return convertItem(obj)
			}
		} else if let urlobj = item as? KLURL {
			if let url = urlobj.url {
				return .image(url)
			}
		} else if let url = item as? URL {
			return .image(url)
		}
		CNLog(logLevel: .error, message: "Unsupoorted object", atFunction: #function, inFile: #file)
		return nil
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


/*
public class CNCollection
{
	public enum CollectionImage {
		case none
		case resource(CNSymbol.SymbolType)
		case url(URL)

		public var description: String { get {
			let result: String
			switch self {
			case .none:
				result = "<none>"
			case .resource(let type):
				result = "resource(\(type.name))"
			case .url(let url):
				result = "url(\(url.path)"
			}
			return result
		}}
	}

	private struct CollectionSection {
		var header: String
		var footer: String
		var images: Array<CollectionImage>

		public init(header hdr: String, footer ftr: String, images imgs: Array<CollectionImage>){
			header	= hdr
			footer	= ftr
			images  = imgs
		}
	}

	private var mSections: Array<CollectionSection>

	public init(){
		mSections = []
	}

	public func value(section sec: Int, item itm: Int) -> CollectionImage {
		if 0<=sec && sec<mSections.count {
			let sect = mSections[sec]
			if 0<=itm && itm<sect.images.count {
				return sect.images[itm]
			}
		}
		return .none
	}

	public func add(header hdr: String, footer ftr: String, images imgs: Array<CollectionImage>) {
		let newsect = CollectionSection(header: hdr, footer: ftr, images: imgs)
		mSections.append(newsect)
	}
}
*/


