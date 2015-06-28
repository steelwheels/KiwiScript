/**
 * @file	KEPreference.m
 * @brief	Extend KEPreference class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */


#import "KEPreference.h"

@interface KEPreference ()
@property (assign, nonatomic) BOOL	doUseConsole ;
@end

@implementation KEPreference

+ (KEPreference *) sharedPreference
{
	static KEPreference * s_preference = nil ;
	if(s_preference == nil){
		s_preference = [[KEPreference alloc] init] ;
	}
	return s_preference ;
}

- (instancetype) init
{
	if((self = [super init]) != nil){
		self.doUseConsole		= NO ;
	}
	return self ;
}

@end
