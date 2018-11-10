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

	public override init(context ctxt: KEContext){
		super.init(context: ctxt)
		setup(context: ctxt)
	}

	private func setup(context ctxt: KEContext){
		super.set(KEOperationObject.isCanceledItem, JSValue(bool: false, in: ctxt))
	}
}

