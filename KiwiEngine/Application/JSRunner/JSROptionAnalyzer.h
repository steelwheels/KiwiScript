/**
 * @file	JSROptionAnalyer.h
 * @brief	Define JSROptionAnalyzer class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import <Foundation/Foundation.h>
#import "JSRForwarders.h"

@interface JSROptionAnalyzer : NSObject

+ (JSRConfig *) analyzeWithCount: (int) argc withArguments: (const char **) argv ;

@end
