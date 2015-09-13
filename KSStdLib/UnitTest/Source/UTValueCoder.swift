//
//  UTValueCoder.swift
//  KSStdLib
//
//  Created by Tomoo Hamada on 2015/09/08.
//  Copyright © 2015年 Steel Wheels Project. All rights reserved.
//

import Foundation
import JavaScriptCore
import KSStdLib

private func makeJSValue(dict : Dictionary<NSObject, AnyObject>, context : JSContext) -> JSValue {
	return JSValue(object: dict, inContext: context)
}

func testValueCoder() -> Bool
{
	let result = testDirectCoding()
	return result
}

private func testDirectCoding() -> Bool
{
	var result  = true
	let context = JSContext()
	
	/* CGFloat */
	let floatdata : Double = 10.1
	let floatval = KSValueCoder.encodeDouble("key", val: floatdata, context: context)
	decodeValue(floatval)
	if let revfloat = KSValueCoder.decodeDouble(floatval, key: "key") {
		if revfloat == 10.1 {
			print(" Enc/Dec CGFloat ... OK")
		} else {
			print(" Enc/Dec CGFloat ... NG (\(revfloat))")
			result = false
		}
	} else {
		print(" Enc/Dec CGFloat ... NG (nil)")
		result = false
	}
	
	/* CGPoint */
	let point = CGPoint(x:123.0, y:456.7)
	let pointval = KSValueCoder.encodePoint(point, context: context)
	decodeValue(pointval)
	if let revpoint = KSValueCoder.decodePoint(pointval){
		if revpoint.x == 123.0 && revpoint.y == 456.7 {
			print(" Enc/Dec CGPoint ... OK")
		} else {
			print(" Enc/Dec CGPoint ... NG (\(revpoint))")
			result = false
		}
	} else {
		print(" Enc/Dec CGPoint ... NG (nil)")
		result = false
	}

	/* CGSize */
	let size = CGSize(width: 10.1, height: 20.2)
	let sizeval = KSValueCoder.encodeSize(size, context: context)
	decodeValue(sizeval)
	if let revsize = KSValueCoder.decodeSize(sizeval) {
		if revsize.width == 10.1 && revsize.height == 20.2 {
			print(" Enc/Dec CGSize ... OK")
		} else {
			print(" Enc/Dec CGSize ... NG (\(revsize))")
			result = false
		}
	} else {
		print(" Enc/Dec CGSize ... NG (nil)")
		result = false
	}
	return result
}
