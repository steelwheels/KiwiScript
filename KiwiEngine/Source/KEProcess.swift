/**
 * @file	KEProcess.swift
 * @brief	Define KEProcess class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

/*
public class KEProcess: KEObject
{
//	private static let typeItem		= "type"
	private static let isExecutingItem	= "isExecuting"
	private static let isFinishedItem	= "isFinished"
	private static let isCanceledItem	= "isCanceled"

	public init(context ctxt: KEContext, config conf: KEConfig) {
		let myconf = KEConfig(applicationType: conf.applicationType, processType: .process, doStrict: conf.doStrict, logLevel: conf.logLevel)
		super.init(context: ctxt)

		switch conf.processType {
		case .main, .process, .thread:
			isExecuting = true
		case .operation:
			isExecuting = false
		}
		isFinished	= false
		isCanceled	= false
	}

	public var type: KEApplicationType {
		get	   {
			let immval = getInt32(name: KEProcess.kindItem)
			if let kind = KEApplicationType(rawValue: immval) {
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
*/

