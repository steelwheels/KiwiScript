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
	var characterA:		KLImage	{ get }
	var chevronBackward:	KLImage { get }
	var chevronForward:	KLImage { get }
	var handRaised:		KLImage { get }
	var paintbrush:		KLImage { get }
	var pencil:		KLImage { get }
	var questionmark:	KLImage { get }
}

@objc public class KLSymbol: NSObject, KLSymbolProtocol
{
	private var mContext: KEContext

	public init(context ctxt: KEContext){
		mContext = ctxt
	}

	public var characterA:      KLImage { get { return load(type: .characterA)	}}
	public var chevronBackward: KLImage { get { return load(type: .chevronBackward)	}}
	public var chevronForward:  KLImage { get { return load(type: .chevronForward)  }}
	public var handRaised:      KLImage { get { return load(type: .handRaised)	}}
	public var paintbrush:      KLImage { get { return load(type: .paintbrush)	}}
	public var pencil:	    KLImage { get { return load(type: .pencil)		}}
	public var questionmark:    KLImage { get { return load(type: .questionmark)	}}

	private func load(type typ: CNSymbol.SymbolType) -> KLImage {
		let img = CNSymbol.shared.load(symbol: typ)
		return KLImage(image: img, context: mContext)
	}
}

