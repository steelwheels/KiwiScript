//
//  UTJsonEncoder.swift
//  KSStdLib
//
//  Created by Tomoo Hamada on 2015/09/01.
//  Copyright (c) 2015年 Steel Wheels Project. All rights reserved.
//

import Foundation
import KSStdLib
import JavaScriptCore

func testJsonEncoder() -> Bool
{
	return true
}

func decodeValue(value : JSValue)
{
	let encoder = KSJsonEncoder() ;
	let textbuf = encoder.encode(value)
}
