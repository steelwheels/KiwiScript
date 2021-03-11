/**
 * @file	KLLock.swift
 * @brief	Define KLLock class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public protocol KLLockProtocol: JSExport {
	func lock()
	func unlock()
	func discard()
}

@objc public class KLLock: NSObject, KLLockProtocol
{
	private var mLock:	NSLock?

	public override init() {
		mLock = NSLock()
	}

	public func lock() {
		if let lock = mLock {
			lock.lock()
		} else {
			NSLog("Failed to lock at \(#function)")
		}
	}

	public func unlock() {
		if let lock = mLock {
			lock.unlock()
		} else {
			NSLog("Failed to lock at \(#function)")
		}
	}

	public func discard() {
		mLock = nil
	}
}
