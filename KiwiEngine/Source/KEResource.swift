/**
 * @file	KEResource.swift
 * @brief	Define KEResource class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KEResource
{
	public static let ApplicationCategory		= "application"
	public static let LibrariesCategory		= "libraries"
	public static let ScriptsCategory		= "scripts"

	public static let DefaultIdentifier		= "_default"

	public typealias LoaderFunc	= CNResource.LoaderFunc

	private var mResource:		CNResource
	private var mFileLoader:	LoaderFunc

	public var baseURL: URL { get { return mResource.baseURL }}

	public init(baseURL url: URL){
		mResource = CNResource(baseURL: url)
		mFileLoader = {
			(_ url: URL) -> Any? in
			do {
				return try String(contentsOf: url)
			} catch {
				return nil
			}
		}

		/* Setup categories */
		mResource.allocate(category: KEResource.ApplicationCategory, loader: mFileLoader)
		mResource.allocate(category: KEResource.LibrariesCategory, loader: mFileLoader)
		mResource.allocate(category: KEResource.ScriptsCategory, loader: mFileLoader)
	}

	public func toText() -> CNTextSection {
		return mResource.toText()
	}

	/*
	 * application section
	 */
	public func setApplicationScriptPath(localPath path: String){
		mResource.set(category: KEResource.ApplicationCategory, identifier: KEResource.DefaultIdentifier, path: path)
	}

	public func loadApplicationScript() -> String? {
		if let script: String = mResource.load(category: KEResource.ApplicationCategory, identifier: KEResource.DefaultIdentifier, index: 0) {
			return script
		} else {
			return nil
		}
	}

	/*
	 * library section
	 */
	public func addLibraryScriptMap(path pathstr: String){
		mResource.add(category: KEResource.LibrariesCategory, identifier: KEResource.DefaultIdentifier, path: pathstr)
	}

	public func countOfLibraryScripts() -> Int? {
		return mResource.count(category: KEResource.LibrariesCategory, identifier: KEResource.DefaultIdentifier)
	}

	public func loadLibraryScript(index idx: Int) -> String? {
		if let script:String = mResource.load(category: KEResource.LibrariesCategory, identifier: KEResource.DefaultIdentifier, index: idx) {
			return script
		} else {
			return nil
		}
	}

	/*
	 * scripts
	 */
	public func identifiersOfScript() -> Array<String>? {
		return mResource.identifiers(category: KEResource.ScriptsCategory)
	}

	public func addScript(identifier ident: String, path pathstr: String){
		mResource.set(category: KEResource.ScriptsCategory, identifier: ident, path: pathstr)
	}

	public func URLOfScript(identifier ident: String) -> URL? {
		if let url = mResource.fullPathURL(category: KEResource.ScriptsCategory, identifier: ident, index: 0) {
			return url
		} else {
			return nil
		}
	}
}

