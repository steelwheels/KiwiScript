/**
 * @file	UnitTest.m
 * @brief	Main program for unit test
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import <Foundation/Foundation.h>
#import "UnitTest.h"

static void printTitle(const char * title) ;

int main(int argc, const char * argv[]) {
	(void) argc ; (void) argv ;
	
	BOOL result = YES ;
	@autoreleasepool {
		printTitle("KEEngine") ;
		result &= testEngine() ;
		
	}
	return result ? 0 : 1 ;
}

static inline void
printLine(void)
{
	unsigned int i ;
	for(i=0 ; i<40 ; i++){
		fputc('*', stdout) ;
	}
	fputc('\n', stdout) ;
}

static void printTitle(const char * title)
{
	printLine() ;
	printf("* %s\n", title) ;
	printLine() ;
}