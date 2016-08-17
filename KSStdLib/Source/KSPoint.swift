/**
 * @file	KSPoint.swift
 * @brief	Define KSPoint class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation
import CoreGraphics
import JavaScriptCore

@objc protocol KSPointProtorol : JSExport {
	var x : Double { get set }
	var y : Double { get set }
}

@objc public class KSPoint: NSObject, KSPointProtorol
{
	public var setX: ((value: CGFloat) -> Void)?	= nil
	public var getX: (() -> CGFloat)?		= nil
	public var setY: ((value: CGFloat) -> Void)?	= nil
	public var getY: (() -> CGFloat)?		= nil
	
	public var x: Double {
		get {
			if let getfunc = getX {
				return Double(getfunc())
			} else {
				return 0.0
			}
		}
		set(newval) {
			setX?(value: CGFloat(newval))
		}
	}
	
	public var y: Double {
		get {
			if let getfunc = getY {
				return Double(getfunc())
			} else {
				return 0.0
			}
		}
		set(newval) {
			setY?(value: CGFloat(newval))
		}
	}
}
