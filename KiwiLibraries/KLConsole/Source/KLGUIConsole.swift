/**
* @file		KLGUIConsole.swift
* @brief	Define KLGUIConsole class
* @par Copyright
*   Copyright (C) 2015 Steel Wheels Project
*/

import Foundation
import JavaScriptCore
import KCConsoleView

class KLGUIConsole : KLConsole
{
	var consoleView : KCConsoleView
	
	init(view : KCConsoleView){
		consoleView = view
		super.init()
	}
	
	override func putJSValue(str : JSValue){
		consoleView.appendText(str.description)
	}
}

