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

		let type = KEEnumType(typeName: "ValueType")
		type.add(members: [
			KEEnumType.Member(name: "nullType", 		value: Int32(CNValueType.nullType.rawValue)),
			KEEnumType.Member(name: "boolType", 		value: Int32(CNValueType.boolType.rawValue)),
			KEEnumType.Member(name: "numberType", 		value: Int32(CNValueType.numberType.rawValue)),
			KEEnumType.Member(name: "stringType", 		value: Int32(CNValueType.stringType.rawValue)),
			KEEnumType.Member(name: "dateType", 		value: Int32(CNValueType.dateType.rawValue)),
			KEEnumType.Member(name: "rangeType", 		value: Int32(CNValueType.rangeType.rawValue)),
			KEEnumType.Member(name: "pointType", 		value: Int32(CNValueType.pointType.rawValue)),
			KEEnumType.Member(name: "sizeType", 		value: Int32(CNValueType.sizeType.rawValue)),
			KEEnumType.Member(name: "rectType", 		value: Int32(CNValueType.rectType.rawValue)),
			KEEnumType.Member(name: "enumType", 		value: Int32(CNValueType.enumType.rawValue)),
			KEEnumType.Member(name: "dictionaryType", 	value: Int32(CNValueType.dictionaryType.rawValue)),
			KEEnumType.Member(name: "arrayType", 		value: Int32(CNValueType.arrayType.rawValue)),
			KEEnumType.Member(name: "URLType", 		value: Int32(CNValueType.URLType.rawValue)),
			KEEnumType.Member(name: "colorType", 		value: Int32(CNValueType.colorType.rawValue)),
			KEEnumType.Member(name: "imageType", 		value: Int32(CNValueType.imageType.rawValue)),
			KEEnumType.Member(name: "objectType", 		value: Int32(CNValueType.objectType.rawValue)),
		])
		mEnumTypes[type.typeName] = type

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

		let axis = KEEnumType(typeName: CNAxis.typeName)
		axis.add(members: [
			KEEnumType.Member(name: "horizontal",	value: CNAxis.horizontal.rawValue),
			KEEnumType.Member(name: "vertical",	value: CNAxis.vertical.rawValue)
		])
		mEnumTypes[axis.typeName] = axis

		let alignment = KEEnumType(typeName: CNAlignment.typeName)
		alignment.add(members: [
			KEEnumType.Member(name: "leading",	value: CNAlignment.leading.rawValue),
			KEEnumType.Member(name: "trailing",	value: CNAlignment.trailing.rawValue),
			KEEnumType.Member(name: "fill",		value: CNAlignment.fill.rawValue),
			KEEnumType.Member(name: "center",	value: CNAlignment.center.rawValue)
		])
		mEnumTypes[alignment.typeName] = alignment

		let distribution = KEEnumType(typeName: CNDistribution.typeName)
		distribution.add(members: [
			KEEnumType.Member(name: "fill",			value: CNDistribution.fill.rawValue),
			KEEnumType.Member(name: "fillProportinally",	value: CNDistribution.fillProportinally.rawValue),
			KEEnumType.Member(name: "fillEqually",		value: CNDistribution.fillEqually.rawValue),
			KEEnumType.Member(name: "equalSpacing",		value: CNDistribution.equalSpacing.rawValue),
		])
		mEnumTypes[distribution.typeName] = distribution

		let fontsize = KEEnumType(typeName: "FontSize")
		fontsize.add(members: [
			KEEnumType.Member(name: "small",	value: Int32(CNFont.smallSystemFontSize)),
			KEEnumType.Member(name: "regular",	value: Int32(CNFont.systemFontSize)),
			KEEnumType.Member(name: "large",	value: Int32(CNFont.systemFontSize * 1.5))
		])
		mEnumTypes[fontsize.typeName] = fontsize

		let textalign = KEEnumType(typeName: "TextAlign")
		textalign.add(members: [
			KEEnumType.Member(name: "left",		value: Int32(NSTextAlignment.left.rawValue)),
			KEEnumType.Member(name: "center",	value: Int32(NSTextAlignment.center.rawValue)),
			KEEnumType.Member(name: "right",	value: Int32(NSTextAlignment.right.rawValue)),
			KEEnumType.Member(name: "justfied",	value: Int32(NSTextAlignment.justified.rawValue)),
			KEEnumType.Member(name: "normal",	value: Int32(NSTextAlignment.natural.rawValue))
		])
		mEnumTypes[textalign.typeName] = textalign

		let authorize = KEEnumType(typeName: "Authorize")
		authorize.add(members: [
			KEEnumType.Member(name: "undetermined",	value: CNAuthorizeState.Undetermined.rawValue),
			KEEnumType.Member(name: "denied",	value: CNAuthorizeState.Denied.rawValue),
			KEEnumType.Member(name: "authorized",	value: CNAuthorizeState.Authorized.rawValue)
		])
		mEnumTypes[authorize.typeName] = authorize

		let animstate = KEEnumType(typeName: "AnimationState")
		animstate.add(members: [
			KEEnumType.Member(name: "idle",		value: CNAnimationState.idle.rawValue),
			KEEnumType.Member(name: "run",		value: CNAnimationState.run.rawValue),
			KEEnumType.Member(name: "pause",	value: CNAnimationState.pause.rawValue)
		])
		mEnumTypes[animstate.typeName] = animstate
	}

	public func search(by typename: String) -> KEEnumType? {
		return mEnumTypes[typename]
	}

	public func add(typeName name: String, enumType etype: KEEnumType) {
		mEnumTypes[name] = etype
	}
}
