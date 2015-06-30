/**
 * @file	UnitTest.h
 * @brief	Main program of UnitTest for KiwiStdlib
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "UnitTest.h"

static void printTitle(const char * title) ;

int
main(int argc, const char * argv[]) {
	(void) argc ;
	(void) argv ;
	
	BOOL	result = YES ;
	@autoreleasepool {
		printTitle("KSConsole") ;
		result &= UTConsole() ;
	}
	return result ? 0 : 1 ;
}

static inline void
printLine(void)
{
	for(unsigned int i=0 ; i<40 ; i++){
		putc('*', stdout) ;
	}
	putc('\n', stdout) ;
}

static void
printTitle(const char * title)
{
	printLine() ;
	printf("* %s\n", title) ;
	printLine() ;
}