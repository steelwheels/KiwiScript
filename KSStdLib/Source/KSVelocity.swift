/**
 * @file	KSVelocity.swift
 * @brief	Define KSVelocity class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation
import JavaScriptCore

@objc protocol KSVelocityProtorol : JSExport {
	var v     : Double { get set }
	var angle : Double { get set }
}

@objc public class KSVelocity: NSObject, KSVelocityProtorol
{
	public var setVCallback: ((value: Double) -> Void)? = nil
	public var setAngleCallback: ((value: Double) -> Void)? = nil
	public var getVCallback: (() -> Double)? = nil
	public var getAngleCallback: (() -> Double)? = nil
	
	var v: Double {
		get {
			if let callback = getVCallback {
				return callback()
			} else {
				return 0.0
			}
		}
		set(newval){
			setVCallback?(value: newval)
		}
	}
	var angle: Double {
		get {
			if let callback = getAngleCallback {
				return callback()
			} else {
				return 0.0
			}
		}
		set(newval){
			setAngleCallback?(value: newval)
		}
	}
}

