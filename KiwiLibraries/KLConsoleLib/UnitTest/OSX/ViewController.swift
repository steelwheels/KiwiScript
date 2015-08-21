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

		kiwiEngine.addGlobalNumber("num", value: NSNumber(double: 1.23))
		let result0 = kiwiEngine.evaluate("num + 1.0")
		if let value0 = result0.value {
			console.puts("Result : \(value0.description)\n")
		} else {
			console.putErrors(result0.errors)
		}
		
		console.addToEngine(kiwiEngine)
		let result1 = kiwiEngine.evaluate("console.puts(\"Hello, World !!\\n\")")
		//let result1 = kiwiEngine.evaluate("console")
		if let value1 = result1.value {
			console.puts("Result : \(value1.description)\n")
		} else {
			console.putErrors(result1.errors)
		}
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

