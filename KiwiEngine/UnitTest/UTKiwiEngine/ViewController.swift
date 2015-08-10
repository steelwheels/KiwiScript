//
//  ViewController.swift
//  UTKiwiEngine
//
//  Created by Tomoo Hamada on 2015/08/10.
//  Copyright (c) 2015年 Steel Wheels Project. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

	@IBOutlet weak var textField: NSTextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		putString("HOO")
		
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

