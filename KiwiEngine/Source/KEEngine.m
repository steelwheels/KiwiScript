/**
 * @file	KEEngine.m
 * @brief	Extend KEEngine class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "KEEngine.h"
#import <Coconut/Coconut.h>

@interface KEEngine ()
- (void) setupContext ;
- (JSValue *) executeInString: (NSString *) program errors: (NSArray **) errors ;
@end

static inline NSInteger
errorCount(KEContext * context)
{
	if(context.runtimeErrors != nil){
		return [context.runtimeErrors count] ;
	} else {
		return 0 ;
	}
}

@implementation KEEngine

- (instancetype) init
{
	if((self = [super init]) != nil){
		virtualMachine = [[JSVirtualMachine alloc] init] ;
		javaScriptContext = [[KEContext alloc] initWithVirtualMachine: virtualMachine] ;
		[self setupContext] ;
	}
	return self ;
}

- (void) setupContext
{
	[javaScriptContext setExceptionHandler:^(JSContext *context, JSValue *value) {
		assert([context isKindOfClass: [KEContext class]]) ;
		KEContext * kcontext = (KEContext *) context ;
		[kcontext addErrorMessage: [value description]] ;
	}];
}

- (JSValue *) executeInURL: (NSURL *) url errors: (NSArray **) errors
{
	NSError * loaderr ;
	NSString * program = [NSString stringWithContentsOfURL:url encoding:NSShiftJISStringEncoding error: &loaderr];
	if(program){
		return [self executeInString: program errors: errors] ;
	} else {
		*errors = [[NSArray alloc] initWithObjects: loaderr, nil] ;
		return nil ;
	}
}

- (JSValue *) executeInURLs: (NSArray *) urls errors: (NSArray **) errors
{
	NSString * program = @"" ;
	NSMutableArray * loaderrs = [[NSMutableArray alloc] initWithCapacity: 8] ;
	for(NSURL * url in urls){
		NSError * loaderr ;
		NSString * subprogram = [NSString stringWithContentsOfURL:url encoding:NSShiftJISStringEncoding error: &loaderr];
		if(subprogram){
			program = [program stringByAppendingString: subprogram] ;
		} else {
			[loaderrs addObject: loaderr] ;
		}
	}
	if([loaderrs count] == 0){
		return [self executeInString: program errors: errors] ;
	} else {
		*errors = loaderrs ;
		return nil ;
	}
}

- (JSValue *) executeInString: (NSString *) program errors: (NSArray **) errors
{
	JSValue * result = [javaScriptContext evaluateScript: program] ;
	if(result != nil){
		if(errorCount(javaScriptContext) > 0){
			result = nil ;
		}
	} else {
		[javaScriptContext addErrorMessage: @"No return value"] ;
	}
	*errors = javaScriptContext.runtimeErrors ;
	return result ;
}

@end

