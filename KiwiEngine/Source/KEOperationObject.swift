/**
 * @file	KEOperationObject.swift
 * @brief	Define KEOperation class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import JavaScriptCore
import Foundation

public class KEOperationObject: KEObject
{
	public static let isCanceledItem	= "isCanceled"
	public static let isExecutingItem	= "isExecuting"
	public static let isFinishedItem	= "isCanceled"

	public override init(context ctxt: KEContext){
		super.init(context: ctxt)
		setup(context: ctxt)
	}

	public var isCanceled: Bool {
		get        { return getFlag(propertyName: KEOperationObject.isCanceledItem) }
		set(value) { setFlag(propertyName: KEOperationObject.isCanceledItem, flag: value) }
	}

	public var isExecuting: Bool {
		get        { return getFlag(propertyName: KEOperationObject.isExecutingItem) }
		set(value) { setFlag(propertyName: KEOperationObject.isExecutingItem, flag: value) }
	}

	public var isFinished: Bool {
		get        { return getFlag(propertyName: KEOperationObject.isFinishedItem) }
		set(value) { setFlag(propertyName: KEOperationObject.isFinishedItem, flag: value) }
	}

	private func setup(context ctxt: KEContext){
		super.set(KEOperationObject.isCanceledItem, JSValue(bool: false, in: ctxt))
		super.set(KEOperationObject.isExecutingItem, JSValue(bool: false, in: ctxt))
		super.set(KEOperationObject.isFinishedItem, JSValue(bool: false, in: ctxt))
	}

	private func getFlag(propertyName pname: String) -> Bool {
		if let val = self.check(pname) {
			if val.isBoolean {
				return val.toBool()
			}
		}
		fatalError("No object at \(#function)")
	}

	private func setFlag(propertyName pname: String, flag flg: Bool) {
		super.set(pname, JSValue(bool: flg, in: context))
	}
}

