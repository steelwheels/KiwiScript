/*
 * @file	main.swift
 * @brief	main function for unit test
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiLibrary
import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public func UTDatabase(context ctxt: KEContext, console cons: CNConsole) -> Bool
{
	let db = CNMainDatabase()
	db.write(identifier: "d0", value: .numberValue(NSNumber(integerLiteral: 1234)))
	db.write(identifier: "d1", value: .pointValue(CGPoint(x: 10.0, y: 12.0)))
	db.commit()
	
	let libdb = KLDatabase(database: db, context: ctxt)
	readdb(database: libdb, identifier: "d0", context: ctxt, console: cons)
	writedb(database: libdb, identifier: "d2", value: -5, context: ctxt, console: cons)
	libdb.commit()
	readdb(database: libdb, identifier: "d2", context: ctxt, console: cons)

	return true
}

private func readdb(database db: KLDatabase, identifier ident: String, context ctxt: KEContext, console cons: CNConsole)
{
	cons.print(string: "read(\(ident)) -> ")
	let identval = JSValue(object: ident, in: ctxt)
	let retval = db.read(identval!)
	retval.toText().print(console: cons, terminal: "")
}

private func writedb(database db: KLDatabase, identifier ident: String, value intval: Int32, context ctxt: KEContext, console cons: CNConsole)
{
	cons.print(string: "write(\(ident), \(intval)) -> ")
	let identval = JSValue(object: ident, in: ctxt)
	let wrtval = JSValue(int32: intval, in: ctxt)
	let retval = db.write(identval!, wrtval!)
	retval.toText().print(console: cons, terminal: "")
}

