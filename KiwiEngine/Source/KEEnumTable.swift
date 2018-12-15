/**
 * @file	KEEnumTable.swift
 * @brief	Define KEEnumTable class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KEEnumTable
{
	public static let shared = KEEnumTable()

	private var mEnumTypes:	Dictionary<String, KEEnumType>

	public var typeNames: Array<String> { get { return Array(mEnumTypes.keys) }}

	private init(){
		mEnumTypes = [:]
		setup()
	}

	private func setup(){
		let appkind = KEEnumType(typeName: "ApplicationKind")
		appkind.add(members: [
			KEEnumType.Member(name: "terminal",		value: KEApplicationKind.Terminal.rawValue),
			KEEnumType.Member(name: "window",		value: KEApplicationKind.Window.rawValue),
			KEEnumType.Member(name: "operation",		value: KEApplicationKind.Operation.rawValue)
		])
		mEnumTypes[appkind.typeName] = appkind

		let exitcode = KEEnumType(typeName: "ExitCode")
		exitcode.add(members: [
			KEEnumType.Member(name: "noError",		value: CNExitCode.NoError.rawValue),
			KEEnumType.Member(name: "internalError",	value: CNExitCode.InternalError.rawValue),
			KEEnumType.Member(name: "commaneLineError",	value: CNExitCode.CommandLineError.rawValue),
			KEEnumType.Member(name: "syntaxError",		value: CNExitCode.SyntaxError.rawValue),
			KEEnumType.Member(name: "exception",		value: CNExitCode.Exception.rawValue)
			])
		mEnumTypes[exitcode.typeName] = exitcode

		let axis = KEEnumType(typeName: "Axis")
		axis.add(members: [
			KEEnumType.Member(name: "horizontal",	value: CNAxis.horizontal.rawValue),
			KEEnumType.Member(name: "vertical",	value: CNAxis.vertical.rawValue)
		])
		mEnumTypes[axis.typeName] = axis

		let alignment = KEEnumType(typeName: "Alignment")
		alignment.add(members: [
			KEEnumType.Member(name: "leading",	value: CNAlignment.leading.rawValue),
			KEEnumType.Member(name: "trailing",	value: CNAlignment.trailing.rawValue),
			KEEnumType.Member(name: "fill",		value: CNAlignment.fill.rawValue),
			KEEnumType.Member(name: "center",	value: CNAlignment.center.rawValue)
		])
		mEnumTypes[alignment.typeName] = alignment

		let textalign = KEEnumType(typeName: "TextAlign")
		textalign.add(members: [
			KEEnumType.Member(name: "left",		value: Int32(NSTextAlignment.left.rawValue)),
			KEEnumType.Member(name: "center",	value: Int32(NSTextAlignment.center.rawValue)),
			KEEnumType.Member(name: "right",	value: Int32(NSTextAlignment.right.rawValue)),
			KEEnumType.Member(name: "justfied",	value: Int32(NSTextAlignment.justified.rawValue)),
			KEEnumType.Member(name: "normal",	value: Int32(NSTextAlignment.natural.rawValue))
		])
		mEnumTypes[textalign.typeName] = textalign

		let color = KEEnumType(typeName: "Color")
		color.add(members: [
			KEEnumType.Member(name: "black",	value: CNColor.Black.rawValue),
			KEEnumType.Member(name: "red",		value: CNColor.Red.rawValue),
			KEEnumType.Member(name: "green",	value: CNColor.Green.rawValue),
			KEEnumType.Member(name: "yellow",	value: CNColor.Yellow.rawValue),
			KEEnumType.Member(name: "blue",		value: CNColor.Blue.rawValue),
			KEEnumType.Member(name: "magenta",	value: CNColor.Magenta.rawValue),
			KEEnumType.Member(name: "cyan",		value: CNColor.Cyan.rawValue),
			KEEnumType.Member(name: "white",	value: CNColor.White.rawValue),
			KEEnumType.Member(name: "min",		value: CNColor.Min.rawValue),
			KEEnumType.Member(name: "max",		value: CNColor.Max.rawValue)
		])
		mEnumTypes[color.typeName] = color

		let authorize = KEEnumType(typeName: "Authorize")
		authorize.add(members: [
			KEEnumType.Member(name: "undetermined",	value: CNAuthorizeState.Undetermined.rawValue),
			KEEnumType.Member(name: "denied",	value: CNAuthorizeState.Denied.rawValue),
			KEEnumType.Member(name: "authorized",	value: CNAuthorizeState.Authorized.rawValue)
		])
		mEnumTypes[authorize.typeName] = authorize
	}

	public func search(by typename: String) -> KEEnumType? {
		return mEnumTypes[typename]
	}
}

public class KEEnumType
{
	public struct Member {
		public var name:	String
		public var value:	Int32

		public init(name nm: String, value val: Int32){
			name  = nm
			value = val
		}
	}

	private var mTypeName:	String
	private var mMembers:	Array<Member>

	public init(typeName name: String){
		mTypeName	= name
		mMembers 	= []
	}

	public var typeName: String {
		get { return mTypeName }
	}

	public var members: Array<Member> {
		get { return mMembers }
	}

	public func add(members memb: Array<Member>){
		mMembers = memb
	}
}
