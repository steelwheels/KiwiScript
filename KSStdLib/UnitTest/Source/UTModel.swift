//
//  UTModel.swift
//  KSStdLib
//
//  Created by Tomoo Hamada on 2016/07/06.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import KSStdLib
import JavaScriptCore
import Canary
import KCGraphics

@objc protocol UTModelProtocol : JSExport {
	var position: KSPoint { get }
	var velocity: KSVelocity { get }
}

@objc public class UTModel: NSObject, UTModelProtocol
{
	private var mPosition: KSPoint
	private var mVelocity: KSVelocity
	
	private var mPositionValue:	CGPoint
	private var mVelocityValue:	KCVelocity
	
	public override init(){
		mPosition	= KSPoint()
		mVelocity	= KSVelocity()
		mPositionValue	= CGPointMake(0.0, 0.0)
		mVelocityValue	= KCVelocity(v:0.0, angle:0.0)
		
		super.init()
		
		mPosition.getXCallback = { () -> Double in
			let x = Double(self.mPositionValue.x)
			print("* mPosition.getXCallback -> \(x)")
			return x
		}
		mPosition.getYCallback = { () -> Double in
			let y = Double(self.mPositionValue.y)
			print("* mPosition.getYCallback -> \(y)")
			return y
		}
		
		mVelocity.getVCallback = { () -> Double in
			let v = Double(self.mVelocityValue.v)
			print("* Velocity.getVCallback -> \(v)")
			return v
		}
		mVelocity.setVCallback = { (value: Double) -> Void in
			print("* mVelocity.setVCallback <- \(value)")
			self.mVelocityValue = KCVelocity(v: CGFloat(value), angle: self.mVelocityValue.angle)
		}
		mVelocity.getAngleCallback = { () -> Double in
			let a = Double(self.mVelocityValue.angle)
			print("* mVelocity.getAngleCallback -> \(a)")
			return a
		}
		mVelocity.setAngleCallback = { (value: Double) -> Void in
			print("* Velocity.setAngleCallback <- \(value)")
			self.mVelocityValue = KCVelocity(v: self.mVelocityValue.v, angle: CGFloat(value))
		}
	}
	
	var position: KSPoint {
		get {
			return mPosition
		}
	}
	
	var velocity: KSVelocity {
		get {
			return mVelocity
		}
	}
	
	public func dump() {
		print("{model \(mPositionValue.description), \(mVelocityValue.shortDescription)")
	}
}

func testModel() -> Bool
{
	let console = CNTextConsole()
	let context = JSContext()
	KSStdLib.setup(context)
	KSStdLib.setupRuntime(context, console: console)
	
	context.exceptionHandler = { context, exception in
		print("JavaScript Error: \(exception)")
	}
	
	let model = UTModel()
	context.setObject(model, forKeyedSubscript: "model")
	
	executeScript(console, context: context, name:"n0", code:"model.velocity.v = 10.0 ; n0=1")
	
	model.dump()
	return true
}

private func executeScript(console : CNConsole, context: JSContext, name: String, code: String) -> Bool
{
	context.evaluateScript(code)
	if let retval : JSValue = context.objectForKeyedSubscript(name) {
		let line = KSValueDescription.description(retval)
		console.print(text: CNConsoleText(string: line))
		return true
	} else {
		print("Can not execute")
		return false
	}
}


