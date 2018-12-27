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
	var size: JSValue { get }
}

@objc public class KLImage: NSObject, KLImageProtocol
{
	private var mImageCore:		KLImageCore
	private var mContext:		KEContext

	public init(imageCore core: KLImageCore, context ctxt: KEContext){
		mImageCore = core
		mContext   = ctxt
	}

	public var size: JSValue {
		get { return JSValue(size: mImageCore.size, in: mContext) }
	}

	public var coreImage: KLImageCore {
		get { return mImageCore }
	}
}

