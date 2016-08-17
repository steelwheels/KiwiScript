/**
* @file		KSSize.swift
* @brief	Extension of CGSize for JavaScriptCore
* @par Copyright
*   Copyright (C) 2016 Steel Wheels Project
*/

import Foundation
import CoreGraphics
import JavaScriptCore

@objc protocol KSSizeProtorol : JSExport {
	var width  : Double { get set }
	var height : Double { get set }
}

@objc public class KSSize: NSObject, KSSizeProtorol
{
	public var setWidth:  ((value: CGFloat) -> Void)?	= nil
	public var getWidth:  (() -> CGFloat)?			= nil
	public var setHeight: ((value: CGFloat) -> Void)?	= nil
	public var getHeight: (() -> CGFloat)?			= nil

	public var width: Double {
		get {
			if let getfunc = getWidth {
				return Double(getfunc())
			} else {
				return 0.0
			}
		}
		set(newval) {
			setWidth?(value: CGFloat(newval))
		}
	}

	public var height: Double {
		get {
			if let getfunc = getHeight {
				return Double(getfunc())
			} else {
				return 0.0
			}
		}
		set(newval) {
			setHeight?(value: CGFloat(newval))
		}
	}
}

