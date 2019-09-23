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
		addCategory(category: KEResource.ApplicationCategory, loader: mFileLoader)
		addCategory(category: KEResource.LibrariesCategory, loader: mFileLoader)
		addCategory(category: KEResource.ScriptsCategory, loader: mFileLoader)
	}

	public func addCategory(category cname: String, loader ldr: @escaping LoaderFunc) {
		super.allocate(category: cname, loader: ldr)
	}

	/*
	 * application section
	 */
	public func addApplicationScriptMap(path pathstr: String){
		super.add(category: KEResource.ApplicationCategory, identifier: KEResource.DefaultIdentifier, path: pathstr)
	}

	public func countOfApplicationScripts() -> Int? {
		return super.count(category: KEResource.ApplicationCategory, identifier: KEResource.DefaultIdentifier)
	}

	public func loadApplicationScript(index idx: Int) -> String? {
		if let script:String = super.load(category: KEResource.ApplicationCategory, identifier: KEResource.DefaultIdentifier, index: idx) {
			return script
		} else {
			return nil
		}
	}

	/*
	 * library section
	 */
	public func addLibraryScriptMap(path pathstr: String){
		super.add(category: KEResource.LibrariesCategory, identifier: KEResource.DefaultIdentifier, path: pathstr)
	}

	public func countOfLibraryScripts() -> Int? {
		return super.count(category: KEResource.LibrariesCategory, identifier: KEResource.DefaultIdentifier)
	}

	public func loadLibraryScript(index idx: Int) -> String? {
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
		super.set(category: KEResource.ScriptsCategory, identifier: ident, path: pathstr)
	}

	public func URLOfScript(identifier ident: String) -> URL? {
		if let url = super.fullPathURL(category: KEResource.ScriptsCategory, identifier: ident, index: 0) {
			return url
		} else {
			return nil
		}
	}
}

