/**
 * @file	KEEnumTable.swift
 * @brief	Define KEEnumTable class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import Foundation

public class KEEnumTable
{
	public struct Member {
		var name:	String
		var value:	Int32

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
