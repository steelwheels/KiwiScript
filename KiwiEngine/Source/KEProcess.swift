/**
 * @file	KEProcess.swift
 * @brief	Define KEProcess class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KEProcess: KEObject
{
	private static let kindItem		= "kind"
	private static let isExecutingItem	= "isExecuting"
	private static let isFinishedItem	= "isFinished"
	private static let isCanceledItem	= "isCanceled"

	public init(context ctxt: KEContext, config conf: KEConfig) {
		super.init(context: ctxt)

		kind	= conf.kind
		switch conf.kind {
		case .Terminal, .Window:
			isExecuting	= true
			isFinished	= false
			isCanceled	= false
		case .Operation:
			isExecuting	= false
			isFinished	= false
			isCanceled	= false
		}
	}

	public var kind: KEApplicationKind {
		get	   {
			let immval = getInt32(name: KEProcess.kindItem)
			if let kind = KEApplicationKind(rawValue: immval) {
				return kind
			} else {
				fatalError("Unknown application kind at \(#function)")
			}
		}
		set(value) { set(name: KEProcess.kindItem, int32Value: value.rawValue) }
	}

	public var isExecuting: Bool {
		get	   { return getBoolean(name: KEProcess.isExecutingItem) }
		set(value) { set(name: KEProcess.isExecutingItem, booleanValue: value) }
	}

	public var isFinished: Bool {
		get	   { return getBoolean(name: KEProcess.isFinishedItem) }
		set(value) { set(name: KEProcess.isFinishedItem, booleanValue: value) }
	}

	public var isCanceled: Bool {
		get	   { return getBoolean(name: KEProcess.isCanceledItem) }
		set(value) { set(name: KEProcess.isCanceledItem, booleanValue: value) }
	}
}

