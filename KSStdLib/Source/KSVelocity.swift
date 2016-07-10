/**
 * @file	KSVelocity.swift
 * @brief	Define KSVelocity class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation
import CoreGraphics
import JavaScriptCore
import Canary

@objc protocol KSVelocityProtorol : JSExport {
	var v     : Double { get set }
	var angle : Double { get set }
}

@objc public class KSVelocity: NSObject, KSVelocityProtorol
{
	public var getV:	(() -> CGFloat)?		= nil
	public var setV:	((newval: CGFloat) -> Void)?	= nil
	public var getAngle:	(() -> CGFloat)?		= nil
	public var setAngle:	((newval: CGFloat) -> Void)?	= nil
	
	public var v: Double {
		get {
			if let getfunc = getV {
				return Double(getfunc())
			} else {
				return 0.0
			}
		}
		set(newval) {
			setV?(newval: CGFloat(newval))
		}
	}
	
	public var angle: Double {
		get {
			if let getfunc = getAngle {
				return Double(getfunc())
			} else {
				return 0.0
			}
		}
		set(newval) {
			setAngle?(newval: CGFloat(newval))
		}
	}
}

