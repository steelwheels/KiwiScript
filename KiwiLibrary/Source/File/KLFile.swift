/**
 * @file	KSFile.swift
 * @brief	Define KSFile class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KiwiEngine
import JavaScriptCore
import Foundation

public protocol KLFileProtocol: JSExport
{
	func open(_ pathstr: JSValue, _ acctype: JSValue) -> JSValue
}

public protocol KLFileObjectProtocol: JSExport
{
	func close() -> JSValue
	func read() -> JSValue
	func write(_ str: JSValue) -> JSValue
}

/*
public class KLFile: NSObject, KLFileProtocol
{
	private var mContext: 		KEContext

	public init(context ctxt: KEContext){
		mContext    = ctxt
	}

	public func open(_ pathval: JSValue, _ accval: JSValue) -> JSValue {
		var result: KLFileObject? = nil
		if pathval.isString && accval.isString {
			if let pathstr = pathval.toString(), let accstr = accval.toString() {
				switch accstr {
				case "r": // read access
					result = openToRead(pathString: pathstr)
				case "w": // write access
					result = openToWrite(pathString: pathstr, doAppend: false)
				case "w+": // append access
					result = openToWrite(pathString: pathstr, doAppend: true)
				default:
					break // nothing have to do
				}
			}
		}
		if let resobj = result {
			return JSValue(object: resobj, in: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	private func openToRead(pathString path: String) -> KLFileObject? {
		let url = pathToURL(pathString: path)
		if let stream = InputStream(url: url) {
			return KLInputFileObject(inputStream: stream, context: mContext)
		}
		return nil
	}

	private func openToWrite(pathString path: String, doAppend append: Bool) -> KLFileObject? {
		let url = pathToURL(pathString: path)
		if let stream = OutputStream(url: url, append: append) {
			return KLOutputFileObject(outputStream: stream, context: mContext)
		}
		return nil
	}

	private func pathToURL(pathString path: String) -> URL {
		let curdir = FileManager.default.currentDirectoryPath
		let cururl = URL(fileURLWithPath: curdir, isDirectory: true)
		return URL(fileURLWithPath: path, relativeTo: cururl)
	}
}

public class KLFileObject: NSObject, KLFileObjectProtocol
{
	public var context: KEContext

	public init(context ctxt: KEContext){
		context = ctxt
	}

	public func close() -> JSValue {
		fatalError("can not happen")
	}
	public func read() -> JSValue {
		fatalError("can not happen")
	}
	public func write(_ str: JSValue) -> JSValue {
		fatalError("can not happen")
	}
}

public class KLInputFileObject: KLFileObject
{
	private var mInputStream:	InputStream

	public init(inputStream stream: InputStream, context ctxt: KEContext){
		mInputStream = stream
		super.init(context: ctxt)
	}

	public override func close() -> JSValue {
		mInputStream.close()
		if mInputStream.streamError == nil {
			return JSValue(int32: 0, in: context)
		} else {
			return JSValue(int32: 1, in: context)
		}
	}

	public override func read() -> JSValue {

	}

	public override func write(_ str: JSValue) -> JSValue {
		return JSValue(int32: 0, in: context)
	}
}

public class KLOutputFileObject: KLFileObject
{
	private var mOutputStream:	OutputStream
	public init(outputStream stream: OutputStream, context ctxt: KEContext){
		mOutputStream = stream
		super.init(context: ctxt)
	}
}

*/

/*
let dir = dirs![0]; //documents directory
var getDocPath = dir.stringByAppendingPathComponent("favlist.txt")

var data : NSData = NSData(contentsOfFile: getDocPath)!
var inputStream : NSInputStream = NSInputStream(data: data)

let bufferSize = 1500
var myBuffer = Array<UInt8>(count: bufferSize, repeatedValue: 0)

inputStream.open()

var bytesRead = inputStream.read(&myBuffer, maxLength: bufferSize)
var textFileContents = NSString(bytes: &myBuffer, length: bytesRead, encoding: NSUTF8StringEncoding)
var a : String = textFileContents!
var textFileContentsTempArray = split(a){$0 == "\n"}

for (var a = 0; a < myFavListMax; a++) {
	myFavList[a] = textFileContentsTempArray[a]
}

inputStream.close()
}
*/


