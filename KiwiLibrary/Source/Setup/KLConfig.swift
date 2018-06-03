/**
 * @file	KLConfig.swift
 * @brief	Define KLConfig class
 * @par Copyright
 *   Copyright (C) 2017-2018 Steel Wheels Project
 */

import KiwiEngine
import Foundation

open class KLConfig
{
	public enum ApplicationKind {
		case TerminalApplication
		case GUIApplication
	}

	public var	mKind		: ApplicationKind
	public var	useStrictMode	: Bool
	public var	verboseMode	: Bool

	public init(){
		mKind		= .TerminalApplication
		useStrictMode	= true
		verboseMode	= false
	}

	public init(kind appkind: ApplicationKind, useStrictMode strict: Bool, doVerbose doverb: Bool) {
		mKind		= appkind
		useStrictMode	= strict
		verboseMode	= doverb
	}
}

