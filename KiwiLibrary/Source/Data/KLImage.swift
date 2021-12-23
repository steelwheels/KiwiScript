/**
 * @file	KLImage.swift
 * @brief	Define KLImage class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation
#if os(OSX)
import AppKit
#else
import UIKit
#endif

@objc public protocol KLImageProtocol: JSExport
{
	var size: JSValue { get }
}

@objc public class KLImage: NSObject, KLImageProtocol, KLEmbeddedObject
{
	public var  coreImage:	CNImage?
	private var mContext:	KEContext

	public init(context ctxt: KEContext) {
		coreImage = nil
		mContext  = ctxt
	}

	public init(image img: CNImage, context ctxt: KEContext) {
		coreImage = img
		mContext  = ctxt
	}

	public func copy(context ctxt: KEContext) -> KLEmbeddedObject {
		let newimg = KLImage(context: ctxt)
		newimg.coreImage = self.coreImage
		return newimg
	}

	public var size: JSValue {
		get { return imageSize().toJSValue(context: mContext) }
	}

	public func imageSize() -> CGSize {
		let size: CGSize
		if let image = self.coreImage {
			size = image.size
		} else {
			size = CGSize(width: 0.0, height: 0.0)
		}
		return size ;
	}
}

