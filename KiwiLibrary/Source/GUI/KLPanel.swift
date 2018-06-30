/**
 * @file	KLPanel.swift
 * @brief	Define functions to contol panels
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public class KLPanel {
	public static var shared = KLPanel()

	private init(){
	}

	#if os(OSX)
	public func openPanel(title tltval: JSValue, isDirectory dirval: JSValue, extensions extval: JSValue, context ctxt: KEContext) -> JSValue {
		let title	= getTitle(value: tltval)
		let filesel 	= getFileSelection(value: dirval)
		let extensions	= getExtensions(value: extval)
		if let url = URL.openPanel(title: title, selection: filesel, fileTypes: extensions) {
			return JSValue(object: KLURL(URL: url, context: ctxt), in: ctxt)
		} else {
			return JSValue(nullIn: ctxt)
		}
	}

	public func savePanel(title tltval: JSValue, outputDirectory odir: JSValue, callback cback: JSValue, context ctxt: KEContext) -> JSValue {
		let title	 = getTitle(value: tltval)
		var outurl: URL? = nil
		if let outstr = getString(value: odir) {
			outurl = URL(string: outstr)
		}
		URL.savePanel(title: title, outputDirectory: outurl, saveFileCallback: {
			(_ url: URL) -> Bool in
			var result = true
			if cback.isObject {
				let urlobj = KLURL(URL: url, context: ctxt)
				if let retval = cback.call(withArguments: [urlobj]) {
					if retval.isBoolean {
						result = retval.toBool()
					}
				}
			}
			return result
		})
		return JSValue(undefinedIn: ctxt)
	}

	private func getTitle(value v: JSValue) -> String {
		if let str = getString(value: v) {
			return str
		} else {
			return "undefined"
		}
	}

	private func getString(value v: JSValue) -> String? {
		if v.isString {
			return v.toString()
		} else {
			return nil
		}
	}

	private func getFileSelection(value v: JSValue) -> URL.CNFileSelection {
		if v.isBoolean {
			if v.toBool() {
				return .SelectDirectory
			}
		}
		return .SelectFile
	}

	private func getExtensions(value v: JSValue) -> Array<String> {
		var result: Array<String> = []
		if v.isArray {
			if let arr = v.toArray() {
				for elm in arr {
					if let str = elm as? String {
						result.append(str)
					}
				}
			}
		}
		return result
	}
	#endif // os(OSX)
}


