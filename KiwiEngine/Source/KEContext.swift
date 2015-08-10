/**
 * @file	KEContext.swift
 * @brief	Extend KEContext class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import JavaScriptCore

public class KEContext : JSContext
{
	internal var mRuntimeErrors : Array<NSError> = [] ;
	
	override init!(){
		let vm = JSVirtualMachine()
		super.init(virtualMachine: vm) ;
	}
	
	override init!(virtualMachine: JSVirtualMachine!) {
		super.init(virtualMachine: virtualMachine)
	}
	
	func runtimeErrors() -> Array<NSError> {
		return mRuntimeErrors ;
	}
	
	func clearRuntimeErrors() {
		mRuntimeErrors = []
	}
	
	func addErrorMessage(message : NSString){
		let error = KEError.parseError(message) ;
		mRuntimeErrors.append(error)
	}
}

