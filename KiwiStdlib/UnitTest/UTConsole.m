/**
 * @file	UTConsole.h
 * @brief	Unit test for KSConsole library
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "UnitTest.h"

BOOL
UTConsole(void)
{
	JSContext * context = [[JSContext alloc] init] ;
	BOOL	    result  = NO ;

	context[@"console"] = [[KCConsoleLib alloc] init] ;
	
	JSValue * retval = [context evaluateScript:@"console.puts(\"Hello JavaScript\")"];
	if(retval && [retval isNumber]){
		NSNumber * num    = [retval toNumber] ;
		NSInteger  val    = [num integerValue] ;
		if(val > 0){
			result = YES ;
		} else {
			printf("[Error] Invalid result value %ld, but 0 is expected\n", val) ;
		}
	} else {
		printf("[Error] Invalid type of return value") ;
	}
	return result ;
}