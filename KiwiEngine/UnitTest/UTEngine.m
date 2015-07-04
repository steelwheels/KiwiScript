/**
 * @file	UTEngine.m
 * @brief	Unit test for KEEngine class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "UnitTest.h"

static BOOL
execEngine(BOOL expres, KEEngine * engine, NSString * program) ;

BOOL
testEngine(void)
{
	BOOL result = YES ;
	
	KEEngine * engine = [[KEEngine alloc] init] ;
	
	result &= execEngine(YES, engine, @"1+1") ;
	result &= execEngine(NO,  engine, @"1 (^^:) 1") ;
	
	return result ;
}

static BOOL
execEngine(BOOL expres, KEEngine * engine, NSString * program)
{
	BOOL		result ;
	NSArray *	errors = nil ;
	JSValue *	retval ;
	
	printf("program = \"%s\"\n", [program UTF8String]) ;
	retval = [engine executeInString: program errors: &errors] ;
	if(retval){
		NSString * desc = [retval description] ;
		printf("exec done : result = %s\n", [desc UTF8String]) ;
		result = YES ;
	} else {
		printf("exec failed : errors = ") ;
		for(NSError * error in errors){
			[error printToFile: stdout] ;
		}
		result = NO ;
	}
	BOOL summary = (expres && result) || (!expres && !result) ;
	if(summary){
		puts("expected result is given : YES") ;
	} else {
		puts("expected result is given : NO") ;
	}
	return summary ;
}
