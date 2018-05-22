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

public class KLColor: KEEnumObject
{
	public static let Black		= CNColor.Black.rawValue
	public static let Red 		= CNColor.Red.rawValue
	public static let Green		= CNColor.Green.rawValue
	public static let Yellow	= CNColor.Yellow.rawValue
	public static let Blue		= CNColor.Blue.rawValue
	public static let Magenta	= CNColor.Magenta.rawValue
	public static let Cyan		= CNColor.Cyan.rawValue
	public static let White		= CNColor.White.rawValue

	public override init(context ctxt: KEContext) {
		super.init(context: ctxt)

		set(name: "black", 	value: KLColor.Black)
		set(name: "red", 	value: KLColor.Red)
		set(name: "green",	value: KLColor.Green)
		set(name: "yello",	value: KLColor.Yellow)
		set(name: "blue",	value: KLColor.Blue)
		set(name: "magenta",	value: KLColor.Magenta)
		set(name: "cyan",	value: KLColor.Cyan)
		set(name: "white",	value: KLColor.White)
	}
}


