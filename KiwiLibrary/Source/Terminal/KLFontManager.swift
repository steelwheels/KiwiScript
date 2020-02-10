/**
 * @file	KLFontManager.swift
 * @brief	Define KLFontManager class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public protocol KLFontManagerProtocol: JSExport
{
	var availableFonts: JSValue { get }
}

@objc public class KLFontManager: NSObject, KLFontManagerProtocol
{
	private var mContext:	KEContext

	public init(context ctxt: KEContext) {
		mContext = ctxt
	}

	public var availableFonts: JSValue {
		let fonts = CNFontManager.shared.availableFonts
		return JSValue(object: fonts, in: mContext)
	}
}
