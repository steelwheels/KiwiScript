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
	public var	kind		: KEConfig.ApplicationKind
	public var	doStrict	: Bool
	public var	doVerbose	: Bool
	public var	scriptFiles	: Array<String>

	public convenience init(kind appkind: KEConfig.ApplicationKind){
		self.init(kind: appkind, useStrictMode: true, doVerbose: false, scriptFiles: [])
	}

	public init(kind appkind: KEConfig.ApplicationKind, useStrictMode strict: Bool, doVerbose doverb: Bool, scriptFiles files: Array<String>) {
		kind		= appkind
		doStrict	= strict
		doVerbose	= doverb
		scriptFiles	= files
	}
}

