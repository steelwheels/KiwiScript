/**
 * @file	KEEnumTable.swift
 * @brief	Define KEEnumTable class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
#if os(OSX)
import AppKit
#else
import UIKit
#endif
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
		let exitcode = KEEnumType(typeName: "ExitCode")
		exitcode.add(members: [
			KEEnumType.Member(name: "noError",		value: CNExitCode.NoError.rawValue),
			KEEnumType.Member(name: "internalError",	value: CNExitCode.InternalError.rawValue),
			KEEnumType.Member(name: "commaneLineError",	value: CNExitCode.CommandLineError.rawValue),
			KEEnumType.Member(name: "syntaxError",		value: CNExitCode.SyntaxError.rawValue),
			KEEnumType.Member(name: "exception",		value: CNExitCode.Exception.rawValue)
			])
		mEnumTypes[exitcode.typeName] = exitcode

		let logcode = KEEnumType(typeName: "LogLevel")
		logcode.add(members: [
			KEEnumType.Member(name: "nolog",		value: Int32(CNConfig.LogLevel.nolog.rawValue)),
			KEEnumType.Member(name: "error",		value: Int32(CNConfig.LogLevel.error.rawValue)),
			KEEnumType.Member(name: "warning",		value: Int32(CNConfig.LogLevel.warning.rawValue)),
			KEEnumType.Member(name: "debug",		value: Int32(CNConfig.LogLevel.debug.rawValue)),
			KEEnumType.Member(name: "detail",		value: Int32(CNConfig.LogLevel.detail.rawValue))
		])
		mEnumTypes[logcode.typeName] = logcode

		let filetype = KEEnumType(typeName: "FileType")
		filetype.add(members: [
			KEEnumType.Member(name: "notExist", 		value: CNFileType.NotExist.rawValue),
			KEEnumType.Member(name: "file", 		value: CNFileType.File.rawValue),
			KEEnumType.Member(name: "directory", 		value: CNFileType.Directory.rawValue),
		])
		mEnumTypes[filetype.typeName] = filetype

		let acctype = KEEnumType(typeName: "AccessType")
		acctype.add(members: [
			KEEnumType.Member(name: "read", 		value: CNFileAccessType.ReadAccess.rawValue),
			KEEnumType.Member(name: "write", 		value: CNFileAccessType.WriteAccess.rawValue),
			KEEnumType.Member(name: "append", 		value: CNFileAccessType.AppendAccess.rawValue),
		])
		mEnumTypes[acctype.typeName] = acctype

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

		let distribution = KEEnumType(typeName: "Distribution")
		distribution.add(members: [
			KEEnumType.Member(name: "fillProportinally",	value: CNDistribution.fillProportinally.rawValue),
			KEEnumType.Member(name: "fillEqually",		value: CNDistribution.fillEqually.rawValue),
			KEEnumType.Member(name: "equalSpacing",		value: CNDistribution.equalSpacing.rawValue),
		])
		mEnumTypes[distribution.typeName] = distribution

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
			KEEnumType.Member(name: "black",	value: CNColor.black.escapeCode()),
			KEEnumType.Member(name: "red",		value: CNColor.red.escapeCode()),
			KEEnumType.Member(name: "green",	value: CNColor.green.escapeCode()),
			KEEnumType.Member(name: "yellow",	value: CNColor.yellow.escapeCode()),
			KEEnumType.Member(name: "blue",		value: CNColor.blue.escapeCode()),
			KEEnumType.Member(name: "magenta",	value: CNColor.magenta.escapeCode()),
			KEEnumType.Member(name: "cyan",		value: CNColor.cyan.escapeCode()),
			KEEnumType.Member(name: "white",	value: CNColor.white.escapeCode()),
			KEEnumType.Member(name: "min",		value: CNColor.black.escapeCode()),
			KEEnumType.Member(name: "max",		value: CNColor.white.escapeCode())
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

	public func add(typeName name: String, enumType etype: KEEnumType) {
		mEnumTypes[name] = etype
	}
}
