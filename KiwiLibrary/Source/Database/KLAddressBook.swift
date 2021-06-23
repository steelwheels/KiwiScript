/**
 * @file	KLAddressBook.swift
 * @brief	Define KLAddressBook class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutDatabase
import JavaScriptCore
import Foundation

public protocol KLAddressBookProtocol: JSExport {
	func isAuthorized() -> Bool
}
