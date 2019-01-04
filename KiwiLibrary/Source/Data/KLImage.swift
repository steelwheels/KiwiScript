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

public class KLImage: KEObject
{
	private let SizeItem		= "size"
	private let CoreItem		= "core"

	public override init(context ctxt: KEContext) {
		super.init(context: ctxt)
		setup(context: ctxt)
	}

	private func setup(context ctxt: KEContext){
		/* Set image property */
		set(CoreItem, JSValue(nullIn: ctxt))

		/* Set size method */
		let sizefunc: @convention(block) () -> JSValue = {
			() -> JSValue in
			return JSValue(size: self.imageSize(), in: self.context)
		}
		set(SizeItem,  JSValue(object: sizefunc, in: ctxt))
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

	public var coreImage: KLImageCore? {
		get {
			let core = get(CoreItem)
			if core.isObject {
				if let image = core.toObject() as? KLImageCore {
					return image
				}
			}
			return nil
		}
		set(newval){
			let newobj: JSValue
			if let val = newval {
				newobj = JSValue(object: val, in: self.context)
			} else {
				newobj = JSValue(nullIn: self.context)
			}
			set(CoreItem, newobj)
		}
	}
}

