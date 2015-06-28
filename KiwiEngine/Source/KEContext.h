/**
 * @file	KEContext.h
 * @brief	Extend KEContext class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import <JavaScriptCore/JavaScriptCore.h>
#import "KEForwarders.h"

@interface KEContext : JSContext

@property (strong, nonatomic) NSMutableArray *	runtimeErrors ;

- (instancetype) init ;
- (instancetype) initWithVirtualMachine: (JSVirtualMachine *) vm ;

- (void) addErrorMessage: (NSString *) message ;

@end
