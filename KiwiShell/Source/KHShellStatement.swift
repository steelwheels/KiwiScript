/**
 * @file	KHShellStatement.swift
 * @brief	Define KHShellStatement class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import Foundation

public struct KHShellStatement
{
	public var 	statement:	String
	public var	inputName:	String?
	public var	outputName:	String?
	public var	errorName:	String?

	public init(statement stmt: String) {
		statement	= stmt
		inputName	= nil
		outputName	= nil
		errorName	= nil
	}
}
