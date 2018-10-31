/**
 * @file	KEException.swift
 * @brief	Extend KEException class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import JavaScriptCore
import Foundation

public class KEException
{
	private var mContext	: KEContext
	private var mValue	: JSValue?

	public init(context ctxt: KEContext, value val: JSValue?) {
		mContext 	= ctxt
		mValue		= val
	}

	public init(context ctxt: KEContext, message msg: String) {
		mContext	= ctxt
		mValue		= JSValue(object: msg, in: ctxt)
	}

	public var description: String {
		get {
			if let val = mValue {
				return val.toString()
			} else {
				return "nil"
			}
		}
	}
}


