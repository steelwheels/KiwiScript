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

public class KLOrientation: KEDefaultObject
{
	static public let Horizontal:		Int32		= 0
	static public let Vertical:		Int32		= 1

	public override init(instanceName iname: String, context ctxt: KEContext){
		super.init(instanceName: iname, context: ctxt)

		set(name: "horizontal",	int32Value: KLOrientation.Horizontal)
		set(name: "vertical",	int32Value: KLOrientation.Vertical)
	}
}

