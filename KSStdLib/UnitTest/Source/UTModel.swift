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
	var size:     KSSize { set get }
}

@objc public class UTModel: NSObject, UTModelProtocol
{
	private var mPosition	: KSPoint
	private var mVelocity	: KSVelocity
	private var mSize	: KSSize
	
	private var mPositionValue: CGPoint
	private var mVelocityValue: CNVelocity
	private var mSizeValue:	    CGSize

	public override init(){
		mPosition	= KSPoint()
		mVelocity	= KSVelocity()
		mSize		= KSSize()
		mPositionValue	= CGPointMake(0.0, 0.0)
		mVelocityValue	= CNVelocity(v: 0.0, angle: 0.0)
		mSizeValue	= CGSizeMake(10.0, 10.0)
		super.init()
		
		mPosition.setX = { (value: CGFloat) -> Void in self.mPositionValue.x = value }
		mPosition.getX = { () -> CGFloat in return self.mPositionValue.x }
		mPosition.setY = { (value: CGFloat) -> Void in self.mPositionValue.y = value }
		mPosition.getY = { () -> CGFloat in return self.mPositionValue.y }
		
		mVelocity.setV = { (value: CGFloat) -> Void in self.mVelocityValue.v = value }
		mVelocity.getV = { () -> CGFloat in return self.mVelocityValue.v }
		mVelocity.setAngle = { (value: CGFloat) -> Void in self.mVelocityValue.angle = value }
		mVelocity.getAngle = { () -> CGFloat in return self.mVelocityValue.angle }
		
		mSize.setWidth =  { (value: CGFloat) -> Void in self.mSizeValue.width = value }
		mSize.getWidth  = { () -> CGFloat in return self.mSizeValue.width }
		mSize.setHeight = { (value: CGFloat) -> Void in self.mSizeValue.height = value }
		mSize.getHeight = { () -> CGFloat in return self.mSizeValue.height }
	}
	
	var position: KSPoint {
		get {	return mPosition	}
		set(newval) { mPosition = newval }
	}
	
	var velocity: KSVelocity {
		get { return mVelocity }
		set(newval) { mVelocity = newval }
	}
	
	var size: KSSize {
		get { return mSize }
		set(newval) { mSize = newval }
	}
	
	public func dump() {
		print("{model \(mPositionValue.description), \(mVelocityValue.shortDescription), \(mSizeValue.description)")
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
	
	executeScript(console, context: context, name:"n0", code:"model.position.x = 10.0 ; n0=1")
	executeScript(console, context: context, name:"n0", code:"model.position.y = 20.0 ; n0=2")
	executeScript(console, context: context, name:"n0", code:"model.velocity.v = 30.0 ; n0=3")
	executeScript(console, context: context, name:"n0", code:"model.velocity.angle = 3.14 ; n0=4")
	executeScript(console, context: context, name:"n0", code:"model.velocity.angle = 3.14 ; n0=4")
	executeScript(console, context: context, name:"n0", code:"model.size.width = model.size.width + 10.0 ; n0=4")
	
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


