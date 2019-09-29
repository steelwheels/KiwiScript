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
	public static let LibrariesCategory		= "libraries"
	public static let ScriptsCategory		= "scripts"

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
		addCategory(category: KEResource.LibrariesCategory, loader: mFileLoader)
		addCategory(category: KEResource.ScriptsCategory, loader: mFileLoader)
	}

	public func addCategory(category cname: String, loader ldr: @escaping LoaderFunc) {
		super.allocate(category: cname, loader: ldr)
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

	public func URLOfLibrary(identifier ident: String, index idx: Int) -> URL? {
		if let url = super.fullPathURL(category: KEResource.LibrariesCategory, identifier: ident, index: idx) {
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
	 * scripts
	 */
	public func identifiersOfScript() -> Array<String>? {
		return super.identifiers(category: KEResource.ScriptsCategory)
	}

	public func addScript(identifier ident: String, path pathstr: String){
		super.add(category: KEResource.ScriptsCategory, identifier: ident, path: pathstr)
	}

	public func countOfScripts(identifier ident: String) -> Int? {
		return super.count(category: KEResource.ScriptsCategory, identifier: ident)
	}

	public func pathStringOfScript(identifier ident: String, index idx: Int) -> String? {
		return super.pathString(category: KEResource.ScriptsCategory, identifier: ident, index: idx)
	}

	public func URLOfScript(identifier ident: String, index idx: Int) -> URL? {
		if let url = super.fullPathURL(category: KEResource.ScriptsCategory, identifier: ident, index: idx) {
			return url
		} else {
			return nil
		}
	}

	public func loadScript(identifier ident: String, index idx: Int) -> String? {
		if let script:String = super.load(category: KEResource.ScriptsCategory, identifier: ident, index: idx) {
			return script
		} else {
			return nil
		}
	}
}
