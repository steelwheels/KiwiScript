/**
 * @file	JSRMain.m
 * @brief	Main function for JSRunner
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import <KiwiEngine/KiwiEngine.h>
#import <KiwiStdlib/KiwiStdlib.h>
#import "JSROptionAnalyzer.h"
#import "JSRConfig.h"

static int setupLibrary(KEEngine * engine, JSRConfig * config) ;
static int executeScript(KEEngine * engine, JSRConfig * config) ;

int
main(int argc, const char * argv[])
{
	const char * appname = argv[0] ;
	
	int result = 0 ;
	@autoreleasepool {
		JSRConfig * config = [JSROptionAnalyzer analyzeWithCount: argc withArguments: argv] ;
		if(config != nil){
			KEEngine * engine = [[KEEngine alloc] init] ;
			result = setupLibrary(engine, config) ;
			if(result == 0){
				result = executeScript(engine, config) ;
			}
		} else {
			fprintf(stderr, "%s [Error] Invalid arguments\n", appname) ;
			result = 1 ;
		}
	}
	return result ;
}

static int
setupLibrary(KEEngine * engine, JSRConfig * config)
{
	/* Add "console" library */
	KCConsoleLib * console = [[KCConsoleLib alloc] init] ;
	[engine extendByClass: console asName: @"console"] ;
	
	/* Add "arguments" variable to pass command line arguments */
	NSArray * args ;
	if((args = config.arguments) == nil){
		args = [[NSArray alloc] init] ;
	}
	[engine extendByArray: args asName: @"arguments"] ;
	
	return 0 ;
}

static int
executeScript(KEEngine * engine, JSRConfig * config)
{
	NSArray * errors = nil ;
	
	JSValue * result = [engine executeInURLs: config.inputURLs errors: &errors] ;
	if(result){
		NSString * desc = [result description] ;
		printf("%s\n", [desc UTF8String]) ;
		return 0 ;
	} else {
		for(NSError * error in errors){
			[error printToFile: stderr] ;
		}
		return 1 ;
	}
}
