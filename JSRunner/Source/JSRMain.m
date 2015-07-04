/**
 * @file	JSRMain.m
 * @brief	Main function for JSRunner
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import <KiwiEngine/KiwiEngine.h>
#import "JSROptionAnalyzer.h"
#import "JSRConfig.h"

static int executeScript(JSRConfig * config) ;

int
main(int argc, const char * argv[]) {
	int result = 0 ;
	@autoreleasepool {
		JSRConfig * config = [JSROptionAnalyzer analyzeWithCount: argc withArguments: argv] ;
		if(config != nil){
			result = executeScript(config) ;
		} else {
			fputs("Invalid arguments", stderr) ;
		}
	}
	return result ;
}

static int
executeScript(JSRConfig * config)
{
	NSArray * errors = nil ;
	KEEngine * engine = [[KEEngine alloc] init] ;
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
