/**
 * @file	KLContext.swift
 * @brief	Extend KEContext class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import Foundation

extension KEContext
{
	public var console: CNFileConsole {
		get {
			if let consval = self.getValue(name: "console") {
				if consval.isObject {
					if let consobj = consval.toObject() as? KLConsole {
						return consobj.console
					}
				}
			}
			return CNFileConsole()
		}
	}
}

