/**
* @file		KLGUIConsole.swift
* @brief	Define KLGUIConsole class
* @par Copyright
*   Copyright (C) 2015 Steel Wheels Project
*/

import Foundation
import JavaScriptCore
import KCConsoleView

public class KLGUIConsole : KLConsole
{
	var consoleView : KCConsoleView
	
	public init(view : KCConsoleView){
		consoleView = view
		super.init()
	}
	
	override public func puts(str: String){
		consoleView.appendText(str)
	}
}

