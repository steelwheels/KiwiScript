/**
 * @file	KEEngine.h
 * @brief	Extend KEEngine class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "KEContext.h"
#import <Coconut/Coconut.h>

@interface KEEngine : NSObject
{
	JSVirtualMachine *	virtualMachine ;
	KEContext *		javaScriptContext ;
}

- (instancetype) init ;

- (JSValue *) executeInURL: (NSURL *) url errors: (NSArray **) errors ;
- (JSValue *) executeInURLs: (NSArray *) urls errors: (NSArray **) errors ;

@end
