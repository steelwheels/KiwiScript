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
	var characterA:		KLURL { get }
	var chevronBackward:	KLURL { get }
	var chevronDown:	KLURL { get }
	var chevronForward:	KLURL { get }
	var chevronUp:		KLURL { get }
	var handRaised:		KLURL { get }
	var line1P:		KLURL { get }
	var line2P:		KLURL { get }
	var line4P:		KLURL { get }
	var line8P:		KLURL { get }
	var line16P:		KLURL { get }
	var paintbrush:		KLURL { get }
	var questionmark:	KLURL { get }

	func oval(_ filled: JSValue) -> KLURL
	func pencil(_ filled: JSValue) -> KLURL
	func rectangle(_ fille: JSValue, _ rounded: JSValue) -> KLURL
}

@objc public class KLSymbol: NSObject, KLSymbolProtocol
{
	private var mContext: KEContext

	public init(context ctxt: KEContext){
		mContext = ctxt
	}

	public var characterA:      KLURL { get { return URLOfSymbol(type: .characterA)		}}
	public var chevronBackward: KLURL { get { return URLOfSymbol(type: .chevronBackward)	}}
	public var chevronDown:     KLURL { get { return URLOfSymbol(type: .chevronDown)	}}
	public var chevronForward:  KLURL { get { return URLOfSymbol(type: .chevronForward)  	}}
	public var chevronUp:       KLURL { get { return URLOfSymbol(type: .chevronUp)	        }}
	public var handRaised:      KLURL { get { return URLOfSymbol(type: .handRaised)		}}
	public var line1P: 	    KLURL { get { return URLOfSymbol(type: .line1P)		}}
	public var line2P: 	    KLURL { get { return URLOfSymbol(type: .line2P)		}}
	public var line4P: 	    KLURL { get { return URLOfSymbol(type: .line4P)		}}
	public var line8P: 	    KLURL { get { return URLOfSymbol(type: .line8P)		}}
	public var line16P: 	    KLURL { get { return URLOfSymbol(type: .line16P)		}}
	public var paintbrush:      KLURL { get { return URLOfSymbol(type: .paintbrush)		}}
	public var questionmark:    KLURL { get { return URLOfSymbol(type: .questionmark)	}}

	public func oval(_ filled: JSValue) -> KLURL {
		if filled.isBoolean {
			return URLOfSymbol(type: .oval(filled.toBool()))
		} else {
			CNLog(logLevel: .error, message: "Boolean parameter is required", atFunction: #function, inFile: #file)
			return URLOfSymbol(type: .oval(false))
		}
	}

	public func pencil(_ filled: JSValue) -> KLURL {
		if filled.isBoolean {
			return URLOfSymbol(type: .pencil(filled.toBool()))
		} else {
			CNLog(logLevel: .error, message: "Boolean parameter is required", atFunction: #function, inFile: #file)
			return URLOfSymbol(type: .pencil(false))
		}
	}

	public func rectangle(_ filled: JSValue, _ rounded: JSValue) -> KLURL {
		if filled.isBoolean && rounded.isBoolean {
			return URLOfSymbol(type: .rectangle(filled.toBool(), rounded.toBool()))
		} else {
			CNLog(logLevel: .error, message: "Boolean parameter is required", atFunction: #function, inFile: #file)
			return URLOfSymbol(type: .rectangle(false, false))
		}
	}

	private func URLOfSymbol(type typ: CNSymbol.SymbolType) -> KLURL {
		let url = CNSymbol.shared.URLOfSymbol(type: typ)
		return KLURL(URL: url, context: mContext)
	}
}

