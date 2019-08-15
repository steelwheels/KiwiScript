/**
 * @file	KiwiShell.h
 * @brief	Bridge header for Objective-C
 * @par Copyright
 *   Copyright (C) 2018-2019 Steel Wheels Project
 */

#import "TargetConditionals.h"
#if TARGET_OS_IPHONE
#       import <UIKit/UIKit.h>
#else
#       import <Cocoa/Cocoa.h>
#endif

//! Project version number for KiwiShell.
FOUNDATION_EXPORT double KiwiShellVersionNumber;

//! Project version string for KiwiShell.
FOUNDATION_EXPORT const unsigned char KiwiShellVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <KiwiShell/PublicHeader.h>


