/**
 * @file	KLFileInstaller.swift
 * @brief	Define KLFileInstaller class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import JavaScriptCore
import Foundation

class KLFileInstaller: CNFileInstaller
{
	public static let resourceDirectories = ["Game", "Sample", "Test"]
	public static let resourceExtensions  = ["js", "jspkg"]

	open override func installFiles() -> NSError? {
		if let err = super.installFiles() {
			return err
		}

		/* Install KiwiLibrary.d.ts
		 *   Source:       Resource/KiwiLibrary.d.ts
		 *   Destination:  $(HOME)/Library/Types/
		 */
		let homedir = CNPreference.shared.userPreference.homeDirectory
		let dstdir  = homedir.appendingPathComponent("Library")
		if let err = makeTargetDir(directory: dstdir) {
			return err
		}
		if let err = copyFile(targetDirectory: dstdir, sourceDirectory: nil, sourceName: "KiwiLibrary", sourceExtension: "d.ts", sourceClass: KLFileInstaller.self) {
			return err
		}
		return nil
	}
}

