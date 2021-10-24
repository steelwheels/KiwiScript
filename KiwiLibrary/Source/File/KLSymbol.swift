/**
 * @file	KLSymbol.swift
 * @brief	Define KLSymbol class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLSymbolProtocol: JSExport
{
	var characterA:		KLURL	{ get }
	var chevronBackward:	KLURL { get }
	var chevronForward:	KLURL { get }
	var handRaised:		KLURL { get }
	var paintbrush:		KLURL { get }
	var pencil:		KLURL { get }
	var questionmark:	KLURL { get }
}

@objc public class KLSymbol: NSObject, KLSymbolProtocol
{
	private var mContext: KEContext

	public init(context ctxt: KEContext){
		mContext = ctxt
	}

	public var characterA:      KLURL { get { return URLOfSymbol(type: .characterA)		}}
	public var chevronBackward: KLURL { get { return URLOfSymbol(type: .chevronBackward)	}}
	public var chevronForward:  KLURL { get { return URLOfSymbol(type: .chevronForward)  	}}
	public var handRaised:      KLURL { get { return URLOfSymbol(type: .handRaised)		}}
	public var paintbrush:      KLURL { get { return URLOfSymbol(type: .paintbrush)		}}
	public var pencil:	    KLURL { get { return URLOfSymbol(type: .pencil)		}}
	public var questionmark:    KLURL { get { return URLOfSymbol(type: .questionmark)	}}

	private func URLOfSymbol(type typ: CNSymbol.SymbolType) -> KLURL {
		let url = CNSymbol.shared.URLOfSymbol(type: typ)
		return KLURL(URL: url, context: mContext)
	}
}

