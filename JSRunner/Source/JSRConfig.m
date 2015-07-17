/**
 * @file	JSRConfig.m
 * @brief	Define JSRConfig class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "JSRConfig.h"

@implementation JSRConfig

@synthesize doVerbose, arguments ;

- (instancetype) init
{
	if((self = [super init]) != nil){
		self.arguments		= [NSArray arrayWithObjects: nil] ;
		self.doVerbose		= NO ;
		inputURLs = [[NSMutableArray alloc] initWithCapacity: 8] ;
	}
	return self ;
}

- (NSArray *) inputURLs
{
	return inputURLs ;
}

- (void) addInputURL: (NSURL *) url
{
	[inputURLs addObject: url] ;
}

@end
