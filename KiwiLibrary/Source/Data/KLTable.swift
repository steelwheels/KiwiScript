/**
 * @file	KLTable.swift
 * @brief	Define KLTable class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLTable: JSExport
{
	var recordCount: JSValue { get }
	var allFieldNames: JSValue { get }

	func newRecord() -> JSValue
	func record(_ row: JSValue) -> JSValue
	func search(_ val: JSValue, _ field: JSValue) -> JSValue
	func append(_ rcd: JSValue)
	func forEach(_ callback: JSValue)
}

public protocol KLTableCore
{
	func core() -> CNTable
}

