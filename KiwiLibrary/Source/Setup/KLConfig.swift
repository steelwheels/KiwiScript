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

	public var	kind		: ApplicationKind
	public var	useStrictMode	: Bool
	public var	verboseMode	: Bool
	public var	scriptFiles	: Array<String>

	public init(kind appkind: ApplicationKind, useStrictMode strict: Bool, doVerbose doverb: Bool, scriptFiles files: Array<String>) {
		kind		= appkind
		useStrictMode	= strict
		verboseMode	= doverb
		scriptFiles	= files
	}
}

