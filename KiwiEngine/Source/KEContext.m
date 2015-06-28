/**
 * @file	KEContext.m
 * @brief	Extend KEContext class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "KEContext.h"
#import <Coconut/Coconut.h>

@interface KEContext ()
- (void) setupContext ;
@end

@implementation KEContext

- (instancetype) init
{
	if((self = [super init]) != nil){
		[self setupContext] ;
	}
	return self ;
}

- (instancetype) initWithVirtualMachine: (JSVirtualMachine *) vm
{
	if((self = [super initWithVirtualMachine: vm]) != nil){
		[self setupContext] ;
	}
	return self ;
}

- (void) setupContext
{
	self.runtimeErrors = nil ;
}

- (void) addErrorMessage: (NSString *) message
{
	NSError * newerror = [NSError parseErrorWithMessage: message] ;
	if(self.runtimeErrors == nil){
		self.runtimeErrors = [[NSMutableArray alloc] initWithCapacity: 8];
	}
	[self.runtimeErrors addObject: newerror] ;
}

@end
