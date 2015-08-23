/**
 * @file	KLConsole.swift
 * @brief	Extend KLConsole class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import KLStdLib

public class KLConsole : KLOutputStream
{
	public override func putString(str : String){
		print(str)
	}
}

