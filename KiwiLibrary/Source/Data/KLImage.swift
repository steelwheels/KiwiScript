/**
 * @file	KLImage.swift
 * @brief	Define KLImage class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

#if os(OSX)
import AppKit
#else
import UIKit
#endif
import KiwiEngine
import JavaScriptCore
import Foundation

#if os(OSX)
public typealias KLImageCore = NSImage
#else
public typealias KLImageCore = UIImage
#endif

@objc public protocol KLImageProtocol: JSExport
{
	func size() -> JSValue
}

@objc public class KLImage: NSObject, KLImageProtocol, KLEmbeddedObject
{
	public var  coreImage:	KLImageCore?
	private var mContext:	KEContext

	public init(context ctxt: KEContext) {
		coreImage = nil
		mContext  = ctxt
	}

	public func copy(context ctxt: KEContext) -> KLEmbeddedObject {
		let newimg = KLImage(context: ctxt)
		newimg.coreImage = self.coreImage
		return newimg
	}

	public func size() -> JSValue {
		return JSValue(size: imageSize(), in: mContext)
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

