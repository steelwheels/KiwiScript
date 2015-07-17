/**
 * @file	JSRConfig.h
 * @brief	Define JSRConfig class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import <Foundation/Foundation.h>

@interface JSRConfig : NSObject
{
	/** Array of NSURL for input file */
	NSMutableArray *		inputURLs ;
}

@property (assign, nonatomic) NSArray *		arguments ;
@property (assign, nonatomic) BOOL		doVerbose ;

- (instancetype) init ;
- (NSArray *) inputURLs ;
- (void) addInputURL: (NSURL *) url ;

@end
