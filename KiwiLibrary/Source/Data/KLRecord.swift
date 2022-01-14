/**
 * @file	KLRecord.swift
 * @brief	Define KLRecord class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLRecord: JSExport
{
	var fieldCount:		JSValue { get }
	var fieldNames:		JSValue { get }
	var filledFieldNames:	JSValue { get }

	func value(_ name: JSValue) -> JSValue
	func setValue(_ val: JSValue, _ name: JSValue) -> JSValue
}

public protocol KLRecordCore
{
	func core() -> CNRecord
}

