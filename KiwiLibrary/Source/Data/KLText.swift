/**
 * @file	KLText.swift
 * @brief	Define KLText class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation
#if os(OSX)
import AppKit
#else
import UIKit
#endif

@objc public protocol KLTextProtocol: JSExport
{
	func core() -> Any
	func toString() -> JSValue
}

@objc public protocol KLTextLineProtocol: KLTextProtocol, JSExport
{
	func set(_ str: JSValue)
	func append(_ str: JSValue)
	func prepend(_ str: JSValue)
}

@objc public protocol KLTextSectionProtocol: KLTextProtocol, JSExport
{
	var contentCount: JSValue { get }
	func add(_ txt: JSValue)
	func insert(_ txt: JSValue)
	func append(_ str: JSValue)
	func prepend(_ str: JSValue)
}

@objc public protocol KLTextRecordProtocol: KLTextProtocol, JSExport
{
	var columnCount: JSValue { get }
	var columns: JSValue { get }

	func append(_ str: JSValue)
	func prepend(_ str: JSValue)
}

@objc public protocol KLTextTableProtocol: KLTextProtocol, JSExport
{
	var count: JSValue { get }
	var records: JSValue { get }
	func add(_ str: JSValue)
	func insert(_ str: JSValue)
	func append(_ str: JSValue)
	func prepend(_ str: JSValue)
}

private func valueToString(value val: JSValue) -> String? {
	if val.isString {
		if let str = val.toString() {
			return str
		}
	}
	return nil
}

private func valueToText(value val: JSValue) -> CNText? {
	if val.isObject {
		if let obj = val.toObject() as? KLTextProtocol {
			if let core = obj.core() as? CNText {
				return core
			}
		}
	}
	return nil
}

private func valueToRecord(value val: JSValue) -> CNTextRecord? {
	if val.isObject {
		if let obj = val.toObject() as? KLTextProtocol {
			if let core = obj.core() as? CNTextRecord {
				return core
			}
		}
	}
	return nil
}

private func makeString(text txt: CNText, context ctxt: KEContext) -> JSValue {
	let strs = txt.toStrings(indent: 0)
	return JSValue(object: strs.joined(separator: "\n"), in: ctxt)
}

@objc public class KLTextLine: NSObject, KLTextLineProtocol
{
	private var mTextLine: CNTextLine
	private var mContext: KEContext

	public init(context ctxt: KEContext){
		mTextLine = CNTextLine()
		mContext  = ctxt
	}

	public init(text src: CNTextLine, context ctxt: KEContext){
		mTextLine = src
		mContext  = ctxt
	}

	public func core() -> Any {
		return mTextLine
	}

	public func set(_ str: JSValue){
		if let s = valueToString(value: str) {
			mTextLine.set(string: s)
		} else {
			CNLog(logLevel: .error, message: "Invalid parameter", atFunction: #function, inFile: #file)
		}
	}

	public func append(_ str: JSValue){
		if let s = valueToString(value: str) {
			mTextLine.append(string: s)
		} else {
			CNLog(logLevel: .error, message: "Invalid parameter", atFunction: #function, inFile: #file)
		}
	}

	public func prepend(_ str: JSValue){
		if let s = valueToString(value: str) {
			mTextLine.prepend(string: s)
		} else {
			CNLog(logLevel: .error, message: "Invalid parameter", atFunction: #function, inFile: #file)
		}
	}

	public func toString() -> JSValue {
		return makeString(text: mTextLine, context: mContext)
	}
}

@objc public class KLTextSection: NSObject, KLTextSectionProtocol
{
	private var mTextSection:	CNTextSection
	private var mContext: 		KEContext

	public init(context ctxt: KEContext){
		mTextSection	= CNTextSection()
		mContext  	= ctxt
	}

	public init(text src: CNTextSection, context ctxt: KEContext){
		mTextSection	= src
		mContext	= ctxt
	}

	public func core() -> Any {
		return mTextSection
	}

	public var contentCount: JSValue { get {
		return JSValue(int32: Int32(mTextSection.contentCount), in: mContext)
	}}

	public func add(_ txt: JSValue) {
		if let text = valueToText(value: txt) {
			mTextSection.add(text: text)
		} else {
			CNLog(logLevel: .error, message: "Invalid parameter", atFunction: #function, inFile: #file)
		}
	}

	public func insert(_ txt: JSValue) {
		if let text = valueToText(value: txt) {
			mTextSection.insert(text: text)
		} else {
			CNLog(logLevel: .error, message: "Invalid parameter", atFunction: #function, inFile: #file)
		}
	}

	public func append(_ str: JSValue) {
		if let s = valueToString(value: str) {
			mTextSection.append(string: s)
		} else {
			CNLog(logLevel: .error, message: "Invalid parameter", atFunction: #function, inFile: #file)
		}
	}

	public func prepend(_ str: JSValue) {
		if let s = valueToString(value: str) {
			mTextSection.prepend(string: s)
		} else {
			CNLog(logLevel: .error, message: "Invalid parameter", atFunction: #function, inFile: #file)
		}
	}

	public func toString() -> JSValue {
		return makeString(text: mTextSection, context: mContext)
	}
}

@objc public class KLTextRecord: NSObject, KLTextRecordProtocol
{
	private var mTextRecord:	CNTextRecord
	private var mContext: 		KEContext

	public init(context ctxt: KEContext){
		mTextRecord	= CNTextRecord()
		mContext  	= ctxt
	}

	public init(text src: CNTextRecord, context ctxt: KEContext){
		mTextRecord	= src
		mContext	= ctxt
	}

	public var columnCount: JSValue { get {
		return JSValue(int32: Int32(mTextRecord.columnCount), in: mContext)
	}}

	public var columns: JSValue { get {
		return JSValue(object: mTextRecord.columns, in: mContext)
	}}

	public func append(_ str: JSValue) {
		if let s = valueToString(value: str) {
			mTextRecord.append(string: s)
		} else {
			CNLog(logLevel: .error, message: "Invalid parameter", atFunction: #function, inFile: #file)
		}
	}

	public func prepend(_ str: JSValue) {
		if let s = valueToString(value: str) {
			mTextRecord.prepend(string: s)
		} else {
			CNLog(logLevel: .error, message: "Invalid parameter", atFunction: #function, inFile: #file)
		}
	}

	public func core() -> Any {
		return mTextRecord
	}

	public func toString() -> JSValue {
		CNLog(logLevel: .error, message: "Not supported", atFunction: #function, inFile: #file)
		return JSValue(undefinedIn: mContext)
	}
}

@objc public class KLTextTable: NSObject, KLTextTableProtocol
{
	private var mTextTable:		CNTextTable
	private var mContext: 		KEContext

	public init(context ctxt: KEContext){
		mTextTable	= CNTextTable()
		mContext  	= ctxt
	}

	public init(text src: CNTextTable, context ctxt: KEContext){
		mTextTable	= src
		mContext	= ctxt
	}

	public var count: JSValue { get {
		return JSValue(int32: Int32(mTextTable.count), in: mContext)
	}}

	public var records: JSValue { get {
		return JSValue(object: mTextTable.records, in: mContext)
	}}

	public func add(_ rec: JSValue) {
		if let record = valueToRecord(value: rec) {
			mTextTable.add(record: record)
		} else {
			CNLog(logLevel: .error, message: "Invalid parameter", atFunction: #function, inFile: #file)
		}
	}

	public func insert(_ rec: JSValue) {
		if let record = valueToRecord(value: rec) {
			mTextTable.insert(record: record)
		} else {
			CNLog(logLevel: .error, message: "Invalid parameter", atFunction: #function, inFile: #file)
		}
	}

	public func append(_ str: JSValue) {
		if let s = valueToString(value: str) {
			mTextTable.append(string: s)
		} else {
			CNLog(logLevel: .error, message: "Invalid parameter", atFunction: #function, inFile: #file)
		}
	}

	public func prepend(_ str: JSValue) {
		if let s = valueToString(value: str) {
			mTextTable.prepend(string: s)
		} else {
			CNLog(logLevel: .error, message: "Invalid parameter", atFunction: #function, inFile: #file)
		}
	}

	public func core() -> Any {
		return mTextTable
	}

	public func toString() -> JSValue {
		return makeString(text: mTextTable, context: mContext)
	}
}

