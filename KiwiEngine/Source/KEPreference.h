/**
 * @file	KEPreference.h
 * @brief	Extend KEPreference class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import <Foundation/Foundation.h>

@interface KEPreference : NSObject

@property (readonly, nonatomic) BOOL	doUseConsole ;

+ (KEPreference *) sharedPreference ;

- (instancetype) init ;

@end
