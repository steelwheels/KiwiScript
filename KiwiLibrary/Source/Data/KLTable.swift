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
	var defaultFields: JSValue { get }

	func record(_ row: JSValue) -> JSValue
	func pointer(_ val: JSValue, _ field: JSValue) -> JSValue

	func search(_ val: JSValue, _ field: JSValue) -> JSValue
	func append(_ rcd: JSValue)
	func appendPointer(_ ptr: JSValue)
	func remove(_ rcd: JSValue) -> JSValue
	func save() -> JSValue

	func forEach(_ callback: JSValue)

	func toString() -> JSValue
}

public protocol KLTableCore
{
	func core() -> CNTable
}

