//
//  ViewController.swift
//  UTKiwiEngine
//
//  Created by Tomoo Hamada on 2015/08/10.
//  Copyright (c) 2015年 Steel Wheels Project. All rights reserved.
//

import Cocoa
import KiwiEngine

class ViewController: NSViewController {

	@IBOutlet weak var textField: NSTextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		let engine : KEEngine = KEEngine()
		let result = engine.evaluate("1+2")
		if let retval = result.value {
			putString("OK \(retval.description)")
		} else {
			putString("Error \(result.errors.count)")
		}
		
		let error = NSError.parseError("parse error") ;
		NSLog(error.toString())
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}
	
	internal func putString(str : String){
		if let field = textField {
			field.stringValue = str
		}
	}
}

