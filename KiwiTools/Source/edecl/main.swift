/**
 * @file	main..swift
 * @brief	Define main function for edecl command
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import CoconutData
import Foundation

func main(arguments args: Array<String>)
{
	let console = CNFileConsole()
	let cmdline = CommandLineParser(console: console)
	guard let (config, _) = cmdline.parseArguments(arguments: Array(args.dropFirst())) else {
		return
	}
	if config.fileNames.count == 0 {
		/* Dump all default types */
		for etable in CNEnumTable.allEnumTables() {
			for (ename, etype) in etable.allTypes {
				generateEnumDeclaration(enumName: ename, enumType: etype, console: console, config: config)
			}
		}
	}
}

main(arguments: CommandLine.arguments)


