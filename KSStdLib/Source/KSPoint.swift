/**
 * @file	KSPoint.swift
 * @brief	Define KSPoint class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation
import JavaScriptCore

@objc protocol KSPointProtorol : JSExport {
	var x : Double { get set }
	var y : Double { get set }
}

@objc public class KSPoint: NSObject, KSPointProtorol
{
	public var setXCallback: ((value: Double) -> Void)? = nil
	public var setYCallback: ((value: Double) -> Void)? = nil
	public var getXCallback: (() -> Double)? = nil
	public var getYCallback: (() -> Double)? = nil
	
	var x: Double {
		get {
			if let callback = getXCallback {
				return callback()
			} else {
				return 0.0
			}
		}
		set(newval){
			setXCallback?(value: newval)
		}
	}
	var y: Double {
		get {
			if let callback = getYCallback {
				return callback()
			} else {
				return 0.0
			}
		}
		set(newval){
			setYCallback?(value: newval)
		}
	}
}