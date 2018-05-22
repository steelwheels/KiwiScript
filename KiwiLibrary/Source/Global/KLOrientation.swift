/**
 * @file	KLOrientation.swift
 * @brief	Define KLOrientation type
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public class KLOrientation: KEEnumObject
{
	static public let Horizontal:		Int32		= 0
	static public let Vertical:		Int32		= 1

	public override init(context ctxt: KEContext) {
		super.init(context: ctxt)

		set(name: "horizontal", value: KLOrientation.Horizontal)
		set(name: "vertical",   value: KLOrientation.Vertical)
	}
}

