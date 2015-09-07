/**
* @file		KSConsoleStream.swift
* @brief	Define KSConsoleStream class
* @par Copyright
*   Copyright (C) 2015 Steel Wheels Project
*/

import KSStdLib
import KCConsoleView

public class KSConsoleStream : KSOutputStream
{
	var consoleView : KCConsoleView
	
	public init(view : KCConsoleView){
		self.consoleView = view
		super.init()
	}
	
	public override func putString(str : String){
		consoleView.appendText(str)
	}
}


