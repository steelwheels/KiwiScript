/**
 * @file	KLColor.swift
 * @brief	Extend KLColor class
 * @par Copyright
 *   Copyright (C) 2017-2018 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

public class KLColor: KEDefaultObject
{
	public static let Black		= CNColor.Black.rawValue
	public static let Red 		= CNColor.Red.rawValue
	public static let Green		= CNColor.Green.rawValue
	public static let Yellow	= CNColor.Yellow.rawValue
	public static let Blue		= CNColor.Blue.rawValue
	public static let Magenta	= CNColor.Magenta.rawValue
	public static let Cyan		= CNColor.Cyan.rawValue
	public static let White		= CNColor.White.rawValue

	public override init(instanceName iname: String, context ctxt: KEContext){
		super.init(instanceName: iname, context: ctxt)

		set(name: "black",	int32Value: KLColor.Black)
		set(name: "red",	int32Value: KLColor.Red)
		set(name: "green",	int32Value: KLColor.Green)
		set(name: "yellow",	int32Value: KLColor.Yellow)
		set(name: "blue",	int32Value: KLColor.Blue)
		set(name: "magenta",	int32Value: KLColor.Magenta)
		set(name: "cyan",	int32Value: KLColor.Cyan)
		set(name: "white",	int32Value: KLColor.White)
	}
}


