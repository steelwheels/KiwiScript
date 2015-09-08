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
	var result  = true
	let context = JSContext()
	
	/* CGPoint */
	let point = CGPoint(x:123.0, y:456.7)
	let pointval = makeJSValue(KSValueCoder.encodePoint(point), context: context)
	decodeValue(pointval)
	let revpoint = KSValueCoder.decodePoint(pointval.toDictionary())
	if revpoint.x == 123.0 && revpoint.y == 456.7 {
		print(" Enc/Dec CGPoint ... OK")
	} else {
		print(" Enc/Dec CGPoint ... NG")
		result = false
	}

	/* CGSize */
	let size = CGSize(width: 10.1, height: 20.2)
	let sizeval = makeJSValue(KSValueCoder.encodeSize(size), context: context)
	decodeValue(sizeval)
	let revsize = KSValueCoder.decodeSize(sizeval.toDictionary())
	if revsize.width == 10.1 && revsize.height == 20.2 {
		print(" Enc/Dec CGSize ... OK")
	} else {
		print(" Enc/Dec CGSize ... NG")
		result = false
	}
	return result
}
