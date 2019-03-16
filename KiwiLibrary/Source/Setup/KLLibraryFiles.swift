/**
 * @file	KLLibraryFiles.swift
 * @brief	Define KLLibraryFiles class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import Foundation

public class KLLibraryFiles
{
	public static let shared = KLLibraryFiles()

	private var mLibraryFiles:	Array<URL>

	public var libraryFiles: Array<URL> { get { return mLibraryFiles }}

	private init(){
		mLibraryFiles = []
	}

	public func append(libraryFile file: URL){
		mLibraryFiles.append(file)
	}
}

