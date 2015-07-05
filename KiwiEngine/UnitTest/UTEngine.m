/**
 * @file	UTEngine.m
 * @brief	Unit test for KEEngine class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "UnitTest.h"

static BOOL
execEngine(BOOL expres, KEEngine * engine, NSString * program) ;

static BOOL
callFunc(BOOL expres, KEEngine * engine, NSString * funcname, NSArray * params) ;

BOOL
testEngine(void)
{
	BOOL result = YES ;
	
	KEEngine * engine = [[KEEngine alloc] init] ;
	
	result &= execEngine(YES, engine, @"1+1") ;
	[engine clearContext] ;
	
	result &= execEngine(NO,  engine, @"1 (^^:) 1") ;
	[engine clearContext] ;
	
	{
	  result &= execEngine(YES, engine,  @"function func0(a, b){ return a + b ; }") ;
	  if(result){
		  /* 1st call */
		  NSArray * params = @[@1, @2] ;
		  result &= callFunc(YES, engine, @"func0", params) ;
		  if(result){
			  /* call twice */
			  NSArray * params = @[@3, @4] ;
			  result &= callFunc(YES, engine, @"func0", params) ;
		  }
	  } else {
		  puts("[Error] Skip function call") ;
	  }
	}
	
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

static BOOL
callFunc(BOOL expres, KEEngine * engine, NSString * funcname, NSArray * args)
{
	BOOL		result ;
	NSArray * errors = nil ;
	JSValue * retval = [engine callFunc: funcname withArguments: args errors: &errors] ;
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

