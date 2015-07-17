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
- (void) clearContext ;

- (void) extendByNumber: (NSNumber *) number asName: (NSString *) name ;
- (void) extendByString: (NSString *) str asName: (NSString *) name ;
- (void) extendByArray: (NSArray *) array asName: (NSString *) name ;
- (void) extendByClass: (id <JSExport>) obj asName: (NSString *) name ;

- (JSValue *) executeInString: (NSString *) str errors: (NSArray **) errors ;
- (JSValue *) executeInURL: (NSURL *) url errors: (NSArray **) errors ;
- (JSValue *) executeInURLs: (NSArray *) urls errors: (NSArray **) errors ;

- (JSValue *) callFunc: (NSString *) funcname withArguments: (NSArray *) argv errors: (NSArray **) errors ;

@end
