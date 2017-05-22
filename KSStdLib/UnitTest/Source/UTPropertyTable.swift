/**
 * @file	UTState.swift
 * @brief	Unit test for KSState class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KSStdLib
import Canary

public func testPropertyTable(console cons: CNConsole) -> Bool
{
	let table = KSPropertyTable()

	let res00 = checkError(console: cons, message: "bool", result: table.setBooleanProperty(identifier: "bool0", value: true))
	let res01: Bool
	if let bool0 = table.booleanProperty(identifier: "bool0") {
		if bool0 {
			cons.print(string: "getTest: bool ... OK\n")
			res01 = true
		} else {
			cons.print(string: "getTest: bool ... NG\n")
			res01 = true
		}
	} else {
		Swift.print("getTest: bool ... Error")
		res01 = false
	}

	let res10 = checkError(console: cons, message: "int", result: table.setIntProperty(identifier: "int0", value: -1234))
	let res11 = checkValue(console: cons, message: "int", value: table.intProperty(identifier: "int0"), expected: -1234)

	let res20 = checkError(console: cons, message: "uint", result: table.setUIntProperty(identifier: "uint0", value: 2345))
	let res21 = checkValue(console: cons, message: "uint", value: table.uIntProperty(identifier: "uint0"), expected: 2345)

	let res30 = checkError(console: cons, message: "float", result: table.setFloatProperty(identifier: "float0", value: 1.234))
	let res31 = checkValue(console: cons, message: "float", value: table.floatProperty(identifier: "float0"), expected: 1.234)

	let res40 = checkError(console: cons, message: "double", result: table.setDoubleProperty(identifier: "double0", value: -1.234))
	let res41 = checkValue(console: cons, message: "double", value: table.doubleProperty(identifier: "double0"), expected: -1.234)

	let res50 = checkError(console: cons, message: "string", result: table.setStringProperty(identifier: "string0", value: "hello"))
	let res51: Bool
	if let string0 = table.stringProperty(identifier: "string0") {
		if string0.compare("hello") == ComparisonResult.orderedSame {
			cons.print(string: "getTest: string ... OK\n")
			res51 = true
		} else {
			cons.print(string: "getTest: string ... NG\n")
			res51 = true
		}
	} else {
		cons.print(string: "getTest: string ... Error\n")
		res51 = false
	}

	return res00 && res01 && res10 && res11 && res20 && res21
	 && res30 && res31 && res40 && res41 && res50 && res51
}

private func checkError(console cons: CNConsole, message msg:String, result err: KSPropertyError) -> Bool
{
	cons.print(string: "setTest: \(msg) :")
	switch err {
	case .NoError:
		cons.print(string: " ... OK\n")
		return true
	default:
		cons.print(string: " ... Error\(err.description)\n")
		return false
	}
}

private func checkValue<T:Comparable>(console cons: CNConsole, message msg:String, value val0: T?, expected val1: T) -> Bool
{
	cons.print(string: "getTest: \(msg) :")
	if let v = val0 {
		if v == val1 {
			cons.print(string: " ... OK(\(v))\n")
			return true
		} else {
			cons.print(string: " ... NG(\(v) != \(val1))\n")
			return false
		}
	} else {
		cons.print(string: " ... Error\n")
		return false
	}
}

