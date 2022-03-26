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

	private var mEnumTypes:	Dictionary<String, CNEnumType>

	public var typeNames: Array<String> { get { return Array(mEnumTypes.keys) }}

	private init(){
		mEnumTypes = [:]
		setup()
	}

	private func setup(){
		let exitcode = CNEnumType(typeName: "ExitCode")
		exitcode.add(members: [
			"noError": 		CNExitCode.NoError.rawValue,
			"internalError":	CNExitCode.InternalError.rawValue,
			"commaneLineError":	CNExitCode.CommandLineError.rawValue,
			"syntaxError":		CNExitCode.SyntaxError.rawValue,
			"exception":		CNExitCode.Exception.rawValue
		])
		mEnumTypes[exitcode.typeName] = exitcode

		let logcode = CNEnumType(typeName: "LogLevel")
		logcode.add(members: [
			"nolog":		CNConfig.LogLevel.nolog.rawValue,
			"error":		CNConfig.LogLevel.error.rawValue,
			"warning":		CNConfig.LogLevel.warning.rawValue,
			"debug":		CNConfig.LogLevel.debug.rawValue,
			"detail":		CNConfig.LogLevel.detail.rawValue
		])
		mEnumTypes[logcode.typeName] = logcode

		let valtype = CNEnumType(typeName: "ValueType")
		valtype.add(members: [
			"nullType":		CNValueType.nullType.rawValue,
			"boolType":		CNValueType.boolType.rawValue,
			"numberType":		CNValueType.numberType.rawValue,
			"stringType":		CNValueType.stringType.rawValue,
			"dateType":		CNValueType.dateType.rawValue,
			"rangeType":		CNValueType.rangeType.rawValue,
			"pointType":		CNValueType.pointType.rawValue,
			"sizeType":		CNValueType.sizeType.rawValue,
			"rectType":		CNValueType.rectType.rawValue,
			"enumType":		CNValueType.enumType.rawValue,
			"dictionaryType":	CNValueType.dictionaryType.rawValue,
			"arrayType":		CNValueType.arrayType.rawValue,
			"URLType":		CNValueType.URLType.rawValue,
			"colorType":		CNValueType.colorType.rawValue,
			"imageType":		CNValueType.imageType.rawValue,
			"recordType":		CNValueType.recordType.rawValue,
			"referenceType":	CNValueType.referenceType.rawValue,
			"objectType":		CNValueType.objectType.rawValue
		])
		mEnumTypes[valtype.typeName] = valtype

		let filetype = CNEnumType(typeName: "FileType")
		filetype.add(members: [
			"notExist":		CNFileType.NotExist.rawValue,
			"file":			CNFileType.File.rawValue,
			"directory":		CNFileType.Directory.rawValue
		])
		mEnumTypes[filetype.typeName] = filetype

		let acctype = CNEnumType(typeName: "AccessType")
		acctype.add(members: [
			"read":			CNFileAccessType.ReadAccess.rawValue,
			"write": 		CNFileAccessType.WriteAccess.rawValue,
			"append": 		CNFileAccessType.AppendAccess.rawValue
		])
		mEnumTypes[acctype.typeName] = acctype

		let axis = CNEnumType(typeName: CNAxis.typeName)
		axis.add(members: [
			"horizontal":		CNAxis.horizontal.rawValue,
			"vertical":		CNAxis.vertical.rawValue
		])
		mEnumTypes[axis.typeName] = axis

		let alignment = CNEnumType(typeName: CNAlignment.typeName)
		alignment.add(members: [
			"leading": 		CNAlignment.leading.rawValue,
			"trailing": 		CNAlignment.trailing.rawValue,
			"fill": 		CNAlignment.fill.rawValue,
			"center": 		CNAlignment.center.rawValue
		])
		mEnumTypes[alignment.typeName] = alignment

		let distribution = CNEnumType(typeName: CNDistribution.typeName)
		distribution.add(members: [
			"fill":			CNDistribution.fill.rawValue,
			"fillProportinally":	CNDistribution.fillProportinally.rawValue,
			"fillEqually":		CNDistribution.fillEqually.rawValue,
			"equalSpacing":		CNDistribution.equalSpacing.rawValue
		])
		mEnumTypes[distribution.typeName] = distribution

		let fontsize = CNEnumType(typeName: "FontSize")
		fontsize.add(members: [
			"small":		Int(CNFont.smallSystemFontSize),
			"regular":		Int(CNFont.systemFontSize),
			"large": 		Int(CNFont.systemFontSize * 1.5)
		])
		mEnumTypes[fontsize.typeName] = fontsize

		let textalign = CNEnumType(typeName: "TextAlign")
		textalign.add(members: [
			"left":			NSTextAlignment.left.rawValue,
			"center":		NSTextAlignment.center.rawValue,
			"right":		NSTextAlignment.right.rawValue,
			"justfied":		NSTextAlignment.justified.rawValue,
			"normal":		NSTextAlignment.natural.rawValue
		])
		mEnumTypes[textalign.typeName] = textalign

		let authorize = CNEnumType(typeName: "Authorize")
		authorize.add(members: [
			"undetermined":		CNAuthorizeState.Undetermined.rawValue,
			"denied":		CNAuthorizeState.Denied.rawValue,
			"authorized":		CNAuthorizeState.Authorized.rawValue
		])
		mEnumTypes[authorize.typeName] = authorize

		let animstate = CNEnumType(typeName: "AnimationState")
		animstate.add(members: [
			"idle":			CNAnimationState.idle.rawValue,
			"run":			CNAnimationState.run.rawValue,
			"pause":		CNAnimationState.pause.rawValue
		])
		mEnumTypes[animstate.typeName] = animstate
	}

	public func search(by typename: String) -> CNEnumType? {
		return mEnumTypes[typename]
	}

	public func add(typeName name: String, enumType etype: CNEnumType) {
		mEnumTypes[name] = etype
	}
}
