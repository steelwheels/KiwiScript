/**
 * @file	KSConsoleLib.m
 * @brief	Define KSConsoleLib class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "KSConsoleLib.h"

@implementation KCConsoleLib

- (NSInteger) puts: (NSString *) src
{
	return puts([src UTF8String]) ;
}

@end
