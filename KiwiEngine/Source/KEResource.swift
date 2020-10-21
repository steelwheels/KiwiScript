/**
 * @file	KEResource.swift
 * @brief	Define KEResource class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import Foundation

open class KEResource: CNResource
{
	public static let ApplicationCategory		= "application"
	public static let LibrariesCategory		= "libraries"
	public static let ViewsCategory			= "views"
	public static let ThreadsCategory		= "threads"

	public static let DefaultIdentifier		= "_default"

	public typealias LoaderFunc	= CNResource.LoaderFunc

	private var mFileLoader:	LoaderFunc

	public var fileLoader: LoaderFunc	{ get { return mFileLoader }}

	public override init(baseURL url: URL){
		mFileLoader = {
			(_ url: URL) -> Any? in
			do {
				return try String(contentsOf: url)
			} catch {
				return nil
			}
		}
		super.init(baseURL: url)

		/* Setup categories */
		addCategory(category: KEResource.ApplicationCategory,	loader: mFileLoader)
		addCategory(category: KEResource.LibrariesCategory,	loader: mFileLoader)
		addCategory(category: KEResource.ThreadsCategory,	loader: mFileLoader)
		addCategory(category: KEResource.ViewsCategory, 	loader: mFileLoader)
	}

	public convenience init(singleFileURL url: URL) {
		let base = url.deletingLastPathComponent()
		let file = url.lastPathComponent
		self.init(baseURL: base)
		setApprication(path: file)
	}

	public func addCategory(category cname: String, loader ldr: @escaping LoaderFunc) {
		super.allocate(category: cname, loader: ldr)
	}

	/*
	 * application section
	 */
	public func setApprication(path pathstr: String){
		super.set(category: KEResource.ApplicationCategory, identifier: KEResource.DefaultIdentifier, path: pathstr)
	}

	public func pathStringOfApplication() -> String? {
		return super.pathString(category: KEResource.ApplicationCategory, identifier: KEResource.DefaultIdentifier, index: 0)
	}

	public func URLOfApplication() -> URL? {
		if let url = super.fullPathURL(category: KEResource.ApplicationCategory, identifier: KEResource.DefaultIdentifier, index: 0) {
			return url
		} else {
			return nil
		}
	}

	public func loadApplication() -> String? {
		if let script:String = super.load(category: KEResource.ApplicationCategory, identifier: KEResource.DefaultIdentifier, index: 0) {
			return script
		} else {
			return nil
		}
	}

	public func storeAppilication(script scr: String) {
		super.store(category: KEResource.ApplicationCategory, identifier: KEResource.DefaultIdentifier, index: 0, content: scr)
	}

	/*
	 * library section
	 */
	public func addLibrary(path pathstr: String){
		super.add(category: KEResource.LibrariesCategory, identifier: KEResource.DefaultIdentifier, path: pathstr)
	}

	public func countOfLibraries() -> Int? {
		return super.count(category: KEResource.LibrariesCategory, identifier: KEResource.DefaultIdentifier)
	}

	public func pathStringOfLibrary(index idx: Int) -> String? {
		return super.pathString(category: KEResource.LibrariesCategory, identifier: KEResource.DefaultIdentifier, index: idx)
	}

	public func URLOfLibrary(index idx: Int) -> URL? {
		if let url = super.fullPathURL(category: KEResource.LibrariesCategory, identifier: KEResource.DefaultIdentifier, index: idx) {
			return url
		} else {
			return nil
		}
	}

	public func loadLibrary(index idx: Int) -> String? {
		if let script:String = super.load(category: KEResource.LibrariesCategory, identifier: KEResource.DefaultIdentifier, index: idx) {
			return script
		} else {
			return nil
		}
	}

	/*
	 * threads
	 */
	public func identifiersOfThread() -> Array<String>? {
		return super.identifiers(category: KEResource.ThreadsCategory)
	}

	public func setThread(identifier ident: String, path pathstr: String){
		super.set(category: KEResource.ThreadsCategory, identifier: ident, path: pathstr)
	}

	public func pathStringOfThread(identifier ident: String) -> String? {
		return super.pathString(category: KEResource.ThreadsCategory, identifier: ident, index: 0)
	}

	public func URLOfThread(identifier ident: String) -> URL? {
		if let url = super.fullPathURL(category: KEResource.ThreadsCategory, identifier: ident, index: 0) {
			return url
		} else {
			return nil
		}
	}

	public func loadThread(identifier ident: String) -> String? {
		if let script:String = super.load(category: KEResource.ThreadsCategory, identifier: ident, index: 0) {
			return script
		} else {
			return nil
		}
	}

	/*
	 * view
	 */
	public func identifiersOfView() -> Array<String>? {
		return super.identifiers(category: KEResource.ViewsCategory)
	}

	public func setView(identifier ident: String, path pathstr: String){
		super.set(category: KEResource.ViewsCategory, identifier: ident, path: pathstr)
	}

	public func pathStringOfView(identifier ident: String) -> String? {
		return super.pathString(category: KEResource.ViewsCategory, identifier: ident, index: 0)
	}

	public func URLOfView(identifier ident: String) -> URL? {
		if let url = super.fullPathURL(category: KEResource.ViewsCategory, identifier: ident, index: 0) {
			return url
		} else {
			return nil
		}
	}

	public func loadView(identifier ident: String) -> String? {
		if let script:String = super.load(category: KEResource.ViewsCategory, identifier: ident, index: 0) {
			return script
		} else {
			return nil
		}
	}
}
