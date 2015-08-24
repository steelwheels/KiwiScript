//
//  ViewController.swift
//  UTConsole
//
//  Created by Tomoo Hamada on 2015/08/25.
//  Copyright (c) 2015年 Steel Wheels Project. All rights reserved.
//

import Cocoa
import KCConsoleView
import KSControlLib
import KiwiEngine

class ViewController: NSViewController {

	@IBOutlet weak var consoleView: KCConsoleView!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		if let view = consoleView {
			let stream = KSConsoleStream(view: view)
			let engine = KEEngine()
			stream.addToEngine(engine) ;
			
			let result = engine.evaluate("console.put(\"Hello, World!!\\n\")")
			if let retval = result.value {
				stream.putString("OK \(retval.description)")
			} else {
				stream.putString("Error \(result.errors.count)")
			}
		}
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

