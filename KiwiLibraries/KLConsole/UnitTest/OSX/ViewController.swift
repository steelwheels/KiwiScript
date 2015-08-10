//
//  ViewController.swift
//  UnitTest
//
//  Created by Tomoo Hamada on 2015/08/10.
//  Copyright (c) 2015年 Steel Wheels Project. All rights reserved.
//

import Cocoa
import KiwiEngine
import KCConsoleView
import KLConsole

class ViewController: NSViewController {

	var kiwiEngine : KEEngine! = nil
	
	@IBOutlet weak var consoleView: KCConsoleView!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		kiwiEngine = KEEngine()
		let console = KLGUIConsole(view: consoleView)
		console.addToEngine(kiwiEngine)
		
		let result = kiwiEngine.evaluate("console.puts(\"Hello, World !!\")")
		if let value = result.value {
			NSLog("Result : \(value.description)")
		} else {
			console.putErrors(result.errors)
		}
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

