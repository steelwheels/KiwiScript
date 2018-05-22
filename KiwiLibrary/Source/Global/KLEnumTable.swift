/**
 * @file	KLEnumTable.swift
 * @brief	Define KLEnumTable function
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import Foundation

public func KESetEnumTable(enumTable table: KEEnumTable, context ctxt: KEContext)
{
	/* Align */
	let align       = KLAlign(context: ctxt)
	table.set(name: "Align", object: align)

	/* Orientation */
	let orientation = KLOrientation(context: ctxt)
	table.set(name: "Orientation", object: orientation)

	/* Color */
	let color       = KLColor(context: ctxt)
	table.set(name: "Color", object: color)
}

