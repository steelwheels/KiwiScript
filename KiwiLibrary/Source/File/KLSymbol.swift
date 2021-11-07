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
	var line1P:		KLURL { get }
	var line2P:		KLURL { get }
	var line4P:		KLURL { get }
	var line8P:		KLURL { get }
	var line16P:		KLURL { get }
	var paintbrush:		KLURL { get }
	var pencil:		KLURL { get }
	var questionmark:	KLURL { get }
	var rectangle:		KLURL { get }
	var rectangleFilled:	KLURL { get }
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
	public var line1P: 	    KLURL { get { return URLOfSymbol(type: .line1P)		}}
	public var line2P: 	    KLURL { get { return URLOfSymbol(type: .line2P)		}}
	public var line4P: 	    KLURL { get { return URLOfSymbol(type: .line4P)		}}
	public var line8P: 	    KLURL { get { return URLOfSymbol(type: .line8P)		}}
	public var line16P: 	    KLURL { get { return URLOfSymbol(type: .line16P)		}}
	public var paintbrush:      KLURL { get { return URLOfSymbol(type: .paintbrush)		}}
	public var pencil:	    KLURL { get { return URLOfSymbol(type: .pencil)		}}
	public var questionmark:    KLURL { get { return URLOfSymbol(type: .questionmark)	}}
	public var rectangle:	    KLURL { get { return URLOfSymbol(type: .rectangle)		}}
	public var rectangleFilled: KLURL { get { return URLOfSymbol(type: .rectangleFilled)	}}

	private func URLOfSymbol(type typ: CNSymbol.SymbolType) -> KLURL {
		let url = CNSymbol.shared.URLOfSymbol(type: typ)
		return KLURL(URL: url, context: mContext)
	}
}

